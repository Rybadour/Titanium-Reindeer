package titanium_reindeer;

import titanium_reindeer.components.ISpatialPartition;

class RTreeFastNode
{
	public var bounds:Rect;
	public var parent:RTreeFastBranch;

	public function new(bounds:Rect)
	{
		this.bounds = bounds;
	}
}

// This class stores the actual data and should only be siblings with itself
class RTreeFastLeaf extends RTreeFastNode
{
	public var value:Int;

	public function new(bounds:Rect, value:Int)
	{
		super(bounds);

		this.value = value;
	}
}

class RTreeFastBranch extends RTreeFastNode
{
	public var children:Array<RTreeFastNode>;
	public var isLeaf:Bool; // if true then this RTreeBranch only contains leafs as children

	public function new(bounds:Rect)
	{
		super(bounds);

		this.children = new Array();
		this.isLeaf = false;
	}

	public function addChild(node:RTreeFastNode):Void
	{
		this.children.push(node);
		node.parent = this;
	}

	public function recalculateBounds():Void
	{
		if (this.children.length > 0)
		{
			var newBounds:Rect = this.children[0].bounds;
			for (i in 1...this.children.length)
			{
				newBounds = Rect.expandToCover(newBounds, this.children[i].bounds);
			}
			this.bounds = newBounds;
		}
	}
}

class RTreeFastInt implements ISpatialPartition
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

	private var root:RTreeFastBranch;
	private var intMap:IntHash<RTreeFastLeaf>;

	public function getBoundingRect():Rect
	{
		return root.bounds;
	}

	public var debugCanvas:String;
	public var debugOffset:Vector2;
	public var debugSteps:Bool;

	public function new()
	{
		maxChildren = 3;

		intMap = new IntHash();
	}

	public function insert(rect:Rect, value:Int):Void
	{
		if (intMap.exists(value))
			return;

		var leaf:RTreeFastLeaf;
		if (root == null)
		{
			root = new RTreeFastBranch(rect.getCopy());
			leaf = new RTreeFastLeaf(rect.getCopy(), value);
			root.addChild(leaf);
			this.intMap.set(value, leaf);
			root.isLeaf = true;
			return;
		}

		var currentNode:RTreeFastBranch = root;
		var intersection:Rect;

		var continueSearching:Bool = true;
		while (continueSearching)
		{
			// Leaf nodes only contain leaf nodes, this is the end of line add this new rect here
			if (currentNode.isLeaf)
			{
				leaf = new RTreeFastLeaf(rect.getCopy(), value);
				this.addChildToNode(currentNode, leaf);
				this.intMap.set(value, leaf);

				continueSearching = false;
			}
			else
			{
				// Find the child branch that will fit this rect while expanding the least
				var leastExpansion:Float = Math.POSITIVE_INFINITY;
				var leastBranch:RTreeFastBranch = null;
				for (node in currentNode.children)
				{
					var branch:RTreeFastBranch = cast(node, RTreeFastBranch);
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
					var newBranch:RTreeFastBranch = new RTreeFastBranch(rect.getCopy());
					this.addChildToNode(currentNode, newBranch);

					// And append the new rect and it's value to it
					leaf = new RTreeFastLeaf(rect.getCopy(), value);
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

		if (this.debugSteps)
			this.drawDebug();
	}

	// This auxilary function appends a child node to a parent
	// Will perform a split if the node capacity is breached
	private function addChildToNode(parent:RTreeFastBranch, child:RTreeFastNode):Void
	{
		parent.addChild(child);
		parent.bounds = Rect.expandToCover(parent.bounds, child.bounds);

		// Not full
		if (parent.children.length <= this.maxChildren)
		{
			// If this first child to the parent is a leaf node then set the parent as a leaf holder
			if (parent.children.length == 1 && Std.is(child, RTreeFastLeaf))
				parent.isLeaf = true;
		}
		// Time to split the parent's children
		else
		{
			linearSplit(parent);
		}
	}

	private function linearSplit(parent:RTreeFastBranch):Void
	{
		// If the width is larger then do splitting by comparing on the x-axis
		var compareOnX:Bool = parent.bounds.width > parent.bounds.height;
		var seedA:RTreeFastNode = null; // Left or Top most seed

		// Create the initial branches with beginning seeds
		var children:Array<RTreeFastNode> = new Array();
		while (parent.children.length > 0)
		{
			var node:RTreeFastNode = parent.children.pop();
			if (seedA == null)
			{
				if (compareOnX)
				{
					if (Math.abs(node.bounds.left - parent.bounds.left) < 1)
					{
						seedA = node;
						continue;
					}
				}
				else
				{
					if (Math.abs(node.bounds.top - parent.bounds.top) < 1)
					{
						seedA = node;
						continue;
					}
				}
			}

			children.push(node);
		}

		// Then B is found by finding the closet child to the right or bottom
		// (Because seedA may span the entire width or height making a second seed that touches the opposite end impossible to find in most cases)
		var leastDist:Float = Math.POSITIVE_INFINITY;
		var leastIndex:Int = -1;
		for (i in 0...children.length)
		{
			if (compareOnX)
			{
				if (parent.bounds.right - children[i].bounds.right < leastDist)
				{
					leastDist = parent.bounds.right - children[i].bounds.right;
					leastIndex = i;
				}
			}
			else
			{
				if (parent.bounds.bottom - children[i].bounds.bottom < leastDist)
				{
					leastDist = parent.bounds.bottom - children[i].bounds.bottom;
					leastIndex = i;
				}
			}
		}
		var seedB:RTreeFastNode = children[leastIndex]; // Right or Bottom most seed
		children.splice(leastIndex, 1);

		/* */
		if (seedA == null)
		{
			var x:Int = 2;
		}
		/* */

		var branchA:RTreeFastBranch = new RTreeFastBranch(seedA.bounds.getCopy()); // Left or Top most branch
		branchA.addChild(seedA);
		var branchB:RTreeFastBranch = new RTreeFastBranch(seedB.bounds.getCopy()); // Right or Bottom most branch
		branchB.addChild(seedB);
		while (children.length > 0)
		{
			var node:RTreeFastNode = children.pop();
			var branch:RTreeFastBranch;
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
			branch.addChild(node);
		}

		branchA.isLeaf = parent.isLeaf;
		branchB.isLeaf = parent.isLeaf;
		parent.children = new Array();

		if (branchA.children.length == 1 && !branchA.isLeaf)
			parent.addChild(branchA.children.pop());
		else
			parent.addChild(branchA);

		if (branchB.children.length == 1 && !branchB.isLeaf)
			parent.addChild(branchB.children.pop());
		else
			parent.addChild(branchB);
		parent.isLeaf = false;

		if (this.debugSteps)
			this.drawDebug();
	}

	public function update(newBounds:Rect, value:Int):Void
	{
		if (!this.intMap.exists(value))
			return;

		var leaf:RTreeFastLeaf = this.intMap.get(value);
		leaf.bounds = newBounds;

		this.updateNodeHierarchy(leaf);
	}

	public function remove(value:Int):Void
	{
		if (!this.intMap.exists(value))
			return;

		var leaf:RTreeFastLeaf = this.intMap.get(value);
		this.intMap.remove(value);

		var parent:RTreeFastBranch = leaf.parent;
		leaf.parent = null;

		if (parent.children.length > 1)
		{
			for (i in 0...parent.children.length)
			{
				if (parent.children[i] == leaf)
				{
					parent.children.splice(i, 1);
					break;
				}
			}
		}
		else // Should be length == 1
		{
			parent.children.pop();

			var nextParent:RTreeFastBranch = parent.parent;
			var timeToStop:Bool = false;
			while (nextParent != null)
			{
				if (nextParent.children.length == 1)
					nextParent.children.pop();
				else
				{
					for (i in 0...nextParent.children.length)
					{
						if (nextParent.children[i] == parent)
						{
							nextParent.children.splice(i, 1);
							break;
						}
					}
					timeToStop = true;
				}

				parent.parent = null;
				parent = nextParent;
				if (timeToStop)
					break;
				nextParent = nextParent.parent;
			}

			// No need to recreate the parent's min bounding rect, it's the root
			// Just reset it
			if (!timeToStop)
			{
				this.root = null; 
				return;
			}
		}

		if (parent.children.length == 1 && parent.parent != null)
		{
			if (parent.parent.children.length == 1)
			{
				parent.parent.children.pop();

				var child:RTreeFastNode = parent.children.pop();
				child.parent = parent.parent;

				parent.parent.isLeaf = parent.isLeaf;
				parent.parent.children.push(child);

				parent.parent = null;

				parent = child.parent;
			}
			
			if (!parent.isLeaf)
			{
				var child:RTreeFastBranch = cast(parent.children[0], RTreeFastBranch);
				if (child.children.length == 1)
				{
					parent.children.pop();

					parent.isLeaf = child.isLeaf;
					parent.addChild(child.children.pop());

					child.parent = null;
				}
			}
		}

		// Rebuild parent's min bounding rect
		parent.recalculateBounds();

		this.updateNodeHierarchy(parent);

		if (this.debugSteps)
			this.drawDebug();
	}

	private function updateNodeHierarchy(node:RTreeFastNode):Void
	{
		var updatedNode:RTreeFastNode = node;
		var nextParent:RTreeFastBranch = node.parent;

		while (nextParent != null)
		{
			// If we are not intersecting and this parent is not root then attempt to move the node to a better parent
			if ( !Rect.isIntersecting(nextParent.bounds, updatedNode.bounds) && nextParent.parent != null)
			{
				var closestParent:RTreeFastBranch = null;
				var closestDistance:Float = Math.POSITIVE_INFINITY;
				var parent:RTreeFastBranch;
				var distance:Float;
				for (i in 0...nextParent.parent.children.length)
				{
					parent = cast(nextParent.parent.children[i], RTreeFastBranch);
					// Can't move a leaf to a non-leaf parent
					if (parent.isLeaf != nextParent.isLeaf)
						continue;

					distance = Math.abs(parent.bounds.x - updatedNode.bounds.x) + Math.abs(parent.bounds.y - updatedNode.bounds.y);
					if (closestParent == null || distance < closestDistance)
					{
						closestDistance = distance;
						closestParent = parent;
					}
				}

				// If it's the same parent, just skip the move step
				if (closestParent != nextParent)
				{
					for (i in 0...nextParent.children.length)
					{
						if (nextParent.children[i] == updatedNode)
						{
							nextParent.children.splice(i, 1);
							break;
						}
					}

					// ASSUME: It's okay to move because we would not have picked a branch that has a different isLeaf value
					this.addChildToNode(closestParent, updatedNode);

					// Now ensure that all parents of the new parent expand to fit node
					var currentBranch:RTreeFastBranch = closestParent.parent;
					while (currentBranch != null)
					{
						Rect.expandToCover(currentBranch.bounds, updatedNode.bounds);

						currentBranch = currentBranch.parent;
					}
				}
			}

			// In the case that the original node moved out of this parent, remove the parent if it's empty
			if (nextParent.children.length <= 0)
			{
				if (nextParent.parent != null)
				{
					updatedNode = nextParent.parent;

					// Remove the empty branch from it's parent
					for (i in 0...nextParent.parent.children.length)
					{
						if (nextParent.parent.children[i] == nextParent)
						{
							nextParent.parent.children.splice(i, 1);
							nextParent.parent = null;
							break;
						}
					}
					
					nextParent = updatedNode.parent;
				}
				else
				{
					nextParent = null;
				}
			}
			else
			{
				// If we aren't moving the node then just recalculate the parent's bounds and move on up
				nextParent.recalculateBounds();

				updatedNode = nextParent;
				nextParent = nextParent.parent;
			}
		}
	}

	public function requestValuesIntersectingRect(rect:Rect):Array<Int>
	{
		if (root == null)
			return [];

		var results:Array<Int> = new Array();
		var currentNodes:Array<RTreeFastBranch> = new Array();
		currentNodes.push(this.root);
		var searchNodes:Array<RTreeFastBranch>;

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
						if (Std.is(child, RTreeFastLeaf))
							results.push(cast(child, RTreeFastLeaf).value);
						else
							currentNodes.push(cast(child, RTreeFastBranch));
					}
				}
			}
			continueSearching = anyNonLeafs;
		}

		return results;
	}

	public function requestValuesIntersectingPoint(point:Vector2):Array<Int>
	{
		if (root == null)
			return [];

		var results:Array<Int> = new Array();
		var currentNodes:Array<RTreeFastBranch> = new Array();
		currentNodes.push(this.root);
		var searchNodes:Array<RTreeFastBranch>;

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
					if (child.bounds.isPointInside(point))
					{
						if (Std.is(child, RTreeFastLeaf))
							results.push(cast(child, RTreeFastLeaf).value);
						else
							currentNodes.push(cast(child, RTreeFastBranch));
					}
				}
			}
			continueSearching = anyNonLeafs;
		}

		return results;
	}

	public function drawDebug()
	{
		if (this.root == null)
			return;

		var canvas:Dynamic = js.Lib.document.getElementById(this.debugCanvas);
		var pen:Dynamic = canvas.getContext("2d");

		/* *
		var colors:Array<String> = new Array();
		colors[0] = "#FF0000";
		colors[1] = "#000000";
		colors[2] = "#00FFFF";
		colors[3] = "#FF00FF";
		colors[4] = "#FFFF00";
		colors[5] = "#23FF23";
		/* */

		pen.fillStyle = "#FFFFFF";
		pen.fillRect(0, 0, 1000, 1000);

		pen.strokeStyle = "#000000";

		pen.textAlign = "center";
		pen.textBaseline = "middle";
		pen.font = "20pt Arial";

		var currentNodes:Array<RTreeFastNode> = new Array();
		var nextNodes:Array<RTreeFastNode> = new Array();
		nextNodes.push(this.root);

		var node:RTreeFastNode;
		var level:Int = 0;
		while (nextNodes.length > 0)
		{
			//pen.strokeStyle = colors[level];
			while (nextNodes.length > 0)
				currentNodes.push( nextNodes.pop() );

			while (currentNodes.length > 0)
			{
				node = currentNodes.pop();
				pen.strokeRect(node.bounds.x + debugOffset.x, node.bounds.y + debugOffset.y, node.bounds.width, node.bounds.height);
				pen.strokeText(level+"", node.bounds.x + debugOffset.x + node.bounds.width/2, node.bounds.y + debugOffset.y + node.bounds.height/2);
	
				if (Std.is(node, RTreeFastBranch))
				{
					var branch:RTreeFastBranch = cast(node, RTreeFastBranch);
					for (i in 0...branch.children.length)
					{
						nextNodes.push(branch.children[i]);
					}
				}
			}

			level++;
			/* *
			if (level >= colors.length)
				level = 0;
			/* */
		}
	}
}
