package titanium_reindeer;

class RTreeNode
{
	public var bounds:Rect;

	public function new(bounds:Rect)
	{
		this.bounds = bounds;
	}
}

// This class stores the actual data and should only be siblings with itself
class RTreeLeaf extends RTreeNode
{
	public var value:Int;

	public function new(bounds:Rect, value:Int)
	{
		super(bounds);

		this.value = value;
	}
}

class RTreeBranch extends RTreeNode
{
	public var children:Array<RTreeNode>;
	public var isLeaf:Bool; // if true then this RTreeBranch only contains leafs as children

	public function new(bounds:Rect)
	{
		super(bounds);

		this.children = new Array();
		this.isLeaf = false;
	}
}

class RTreeInt
{
	// Flags and values for optimizations
	public var maxChildren(default, setMaxChildren):Int;
	private function setMaxChildren(value:Int):Int
	{
		if (value > 1)
		{
			maxChildren = value;
		}
		return maxChildren;
	}

	private var root:RTreeBranch;
	private var intMap:IntHash<RTreeLeaf>;

	public function new()
	{
		maxChildren = 3;

		intMap = new IntHash();
	}

	public function insert(rect:Rect, value:Int):Void
	{
		if (intMap.exists(value))
			return;

		var leaf:RTreeLeaf;
		if (root == null)
		{
			root = new RTreeBranch(rect.getCopy());
			leaf = new RTreeLeaf(rect.getCopy(), value);
			root.children.push(leaf);
			this.intMap.set(value, leaf);
			root.isLeaf = true;
			return;
		}

		var currentNode:RTreeBranch = root;
		var intersection:Rect;

		var continueSearching:Bool = true;
		while (continueSearching)
		{
			// Leaf nodes only contain leaf nodes, this is the end of line add this new rect here
			if (currentNode.isLeaf)
			{
				leaf = new RTreeLeaf(rect.getCopy(), value);
				this.addChildToNode(currentNode, leaf);
				this.intMap.set(value, leaf);

				continueSearching = false;
			}
			else
			{
				// Find the child branch that will fit this rect while expanding the least
				var leastExpansion:Float = Math.POSITIVE_INFINITY;
				var leastBranch:RTreeBranch = null;
				for (node in currentNode.children)
				{
					var branch:RTreeBranch = cast(node, RTreeBranch);
					intersection = Rect.getIntersection(branch.bounds, rect);
					if (intersection != null)
					{
						var leastArea:Float = rect.getArea() - intersection.getArea();
						if (leastExpansion > leastArea)
						{
							leastExpansion = leastArea;
							leastBranch = branch;
						}
					}
				}

				// No intersecting branch found, make a new one
				if (leastBranch == null)
				{
					var newBranch:RTreeBranch = new RTreeBranch(rect.getCopy());
					this.addChildToNode(currentNode, newBranch);

					// And append the new rect and it's value to it
					leaf = new RTreeLeaf(rect.getCopy(), value);
					this.addChildToNode(newBranch, leaf);
					this.intMap.set(value, leaf);

					continueSearching = false;
				}
				// Recursive into the least node
				else
				{
					currentNode.bounds = Rect.expandToCover(currentNode.bounds, rect);

					currentNode = leastBranch;
				}
			}
		}
	}

	// This auxilary function appends a child node to a parent
	// Will perform a split if the node capacity is breached
	private function addChildToNode(parent:RTreeBranch, child:RTreeNode):Void
	{
		parent.children.push(child);
		parent.bounds = Rect.expandToCover(parent.bounds, child.bounds);

		// Not full
		if (parent.children.length <= this.maxChildren)
		{
			// If this first child to the parent is a leaf node then set the parent as a leaf holder
			if (parent.children.length == 1 && Std.is(child, RTreeLeaf))
				parent.isLeaf = true;
		}
		// Time to split the parent's children
		else
		{
			linearSplit(parent);
		}
	}

	private function linearSplit(parent:RTreeBranch):Void
	{
		// If the width is larger then do splitting by comparing on the x-axis
		var compareOnX:Bool = parent.bounds.width > parent.bounds.height;
		var seedA:RTreeNode = null; // Left or Top most seed
		var seedB:RTreeNode = null; // Right or Bottom most seed

		// Create the initial branches with beginning seeds
		var children:Array<RTreeNode> = new Array();
		while (parent.children.length > 0)
		{
			var node:RTreeNode = parent.children.pop();
			if (compareOnX)
			{
				if (node.bounds.left == parent.bounds.left && seedA == null)
				{
					seedA = node;
					continue;
				}
				else if (node.bounds.right == parent.bounds.right && seedB == null)
				{
					seedB = node;
					continue;
				}
			}
			else
			{
				if (node.bounds.top == parent.bounds.top && seedA == null)
				{
					seedA = node;
					continue;
				}
				else if (node.bounds.bottom == parent.bounds.bottom && seedB == null)
				{
					seedB = node;
					continue;
				}
			}

			children.push(node);
		}

		var branchA:RTreeBranch = new RTreeBranch(seedA.bounds.getCopy()); // Left or Top most branch
		branchA.children.push(seedA);
		var branchB:RTreeBranch = new RTreeBranch(seedB.bounds.getCopy()); // Right or Bottom most branch
		branchB.children.push(seedB);
		while (children.length > 0)
		{
			var node:RTreeNode = children.pop();
			var branch:RTreeBranch;
			var aDist:Float;
			var bDist:Float;
			if (compareOnX)
			{
				aDist = node.bounds.left - seedA.bounds.left;
				bDist = seedB.bounds.right - node.bounds.right;
			}
			else
			{
				aDist = node.bounds.top - seedA.bounds.top;
				bDist = seedB.bounds.bottom - node.bounds.bottom;
			}

			if (aDist < bDist)
				branch = branchA;
			else if (bDist < aDist)
				branch = branchB;
			else
			{
				if (branchA.children.length < branchB.children.length)
					branch = branchA;
				else
					branch = branchB;
			}

			branch.bounds = Rect.expandToCover(branch.bounds, node.bounds);
			branch.children.push(node);
		}

		branchA.isLeaf = parent.isLeaf;
		branchB.isLeaf = parent.isLeaf;
		parent.children = new Array();
		parent.children.push(branchA);
		parent.children.push(branchB);
		parent.isLeaf = false;
	}

	public function remove(value:Int):Void
	{
		if (this.intMap.exists(value))
		{
			var leaf:RTreeLeaf = this.intMap.get(value);

			var currentBranch:RTreeBranch = this.root;
			// Search for the place of this leaf by colliding with branch min bounds
			while (!currentBranch.isLeaf) 
			{

			}

			// At this point currentBranch should be our parent
			var childLeaf:RTreeLeaf;
			for (i in 0...currentBranch.children.length)
			{
				childLeaf = cast(RTreeLeaf, currentBranch.children[i]);
				if (childLeaf.value == value)
				{
					currentBranch.children.splice(i, 1);
					break;
				}
			}
		}
	}

	public function getIntersectingValues(rect:Rect):Array<Int>
	{
		if (root == null)
			return [];

		var results:Array<Int> = new Array();
		var currentNodes:Array<RTreeBranch> = new Array();
		currentNodes.push(this.root);
		var searchNodes:Array<RTreeBranch>;

		var continueSearching:Bool = true;
		while (continueSearching)
		{
			searchNodes = new Array();
			while (currentNodes.length > 0)
				searchNodes.push(currentNodes.pop());

			var anyNonLeafs:Bool = false;
			for (node in searchNodes)
			{
				if (!node.isLeaf)
					anyNonLeafs = true;

				for (child in node.children)
				{
					if (Rect.isIntersecting(rect, child.bounds))
					{
						if (Std.is(child, RTreeLeaf))
							untyped { results.push(child.value); }
						else
							currentNodes.push(cast(child, RTreeBranch));
					}
				}
			}
			continueSearching = anyNonLeafs;
		}

		return results;
	}
}
