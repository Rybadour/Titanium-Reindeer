package titanium_reindeer.spatial;

import Map;

class RTreePartition<K> implements ISpatialPartition<K>
{
	// Flags and values for optimizations
	public var maxChildren(default, set):Int;
	private function set_maxChildren(value:Int):Int
	{
		if (value > 1)
		{
			this.maxChildren = value;
		}
		return maxChildren;
	}

	private var root:RTreeNode<K>;
	private var mapper:IMap<K, RTreeNode<K>>;

	public function getBoundingRectRegion():RectRegion
	{
		return root.bounds;
	}

	public function new(mapper:IMap<K, RTreeNode<K>>)
	{
		this.mapper = mapper;

		this.maxChildren = 4;
	}

	public function insert(rect:RectRegion, value:K):Void
	{
		if (mapper.exists(value))
			return;

		var leaf:RTreeNode<K>;
		if (root == null)
		{
			root = new RTreeNode(RectRegion.copy(rect));
			leaf = new RTreeNode(RectRegion.copy(rect), value);
			root.addChild(leaf);
			this.mapper.set(value, leaf);
			root.hasOnlyLeaves = true;
			return;
		}

		var currentNode:RTreeNode<K> = root;
		var intersection:RectRegion;

		var parent:RTreeNode<K> = null;
		var continueSearching:Bool = true;
		while (continueSearching)
		{
			// Leaf nodes only contain leaf nodes, this is the end of line add this new rect here
			if (currentNode.hasOnlyLeaves)
			{
				leaf = new RTreeNode(RectRegion.copy(rect), value);
				this.addChildToNode(currentNode, leaf);
				this.mapper.set(value, leaf);

				parent = currentNode;
				continueSearching = false;
			}
			else
			{
				// Find the child branch that will fit this rect while expanding the least
				var leastExpansion:Float = Math.POSITIVE_INFINITY;
				var leastBranch:RTreeNode<K> = null;
				for (node in currentNode.children)
				{
					var branch:RTreeNode<K> = node;
					intersection = Geometry.getIntersectionOfRectRegions(branch.bounds, rect);
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
					var newBranch:RTreeNode<K> = new RTreeNode(RectRegion.copy(rect));
					this.addChildToNode(currentNode, newBranch);

					// And append the new rect and it's value to it
					leaf = new RTreeNode(RectRegion.copy(rect), value);
					this.addChildToNode(newBranch, leaf);
					this.mapper.set(value, leaf);

					parent = newBranch;
					continueSearching = false;
				}
				// Recursive into the least node
				else
				{
					currentNode.bounds = RectRegion.expandToCover(currentNode.bounds, rect);

					currentNode = leastBranch;
				}
			}
		}

		parent = parent.parent;
		while (parent != null)
		{
			parent.recalculateBounds();
			parent = parent.parent;
		}
	}

	// This auxilary function appends a child node to a parent
	// Will perform a split if the node capacity is breached
	private function addChildToNode(parent:RTreeNode<K>, child:RTreeNode<K>):Void
	{
		parent.addChild(child);
		parent.bounds = RectRegion.expandToCover(parent.bounds, child.bounds);

		// Not full
		if (parent.children.length <= this.maxChildren)
		{
			// If this first child to the parent is a leaf node then set the parent as a leaf holder
			if (parent.children.length == 1 && child.isLeaf)
				parent.hasOnlyLeaves = true;
		}
		// Time to split the parent's children
		else
		{
			linearSplit(parent);
		}
	}

	private function linearSplit(parent:RTreeNode<K>):Void
	{
		// If the width is larger then do splitting by comparing on the x-axis
		var compareOnX:Bool = parent.bounds.width > parent.bounds.height;
		var seedA:RTreeNode<K> = null; // Left or Top most seed

		// Create the initial branches with beginning seeds
		var children:Array<RTreeNode<K>> = new Array();
		while (parent.children.length > 0)
		{
			var node:RTreeNode<K> = parent.children.pop();
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
		var seedB:RTreeNode<K> = children[leastIndex]; // Right or Bottom most seed
		children.splice(leastIndex, 1);

		var branchA:RTreeNode<K> = new RTreeNode(RectRegion.copy(seedA.bounds)); // Left or Top most branch
		branchA.addChild(seedA);
		var branchB:RTreeNode<K> = new RTreeNode(RectRegion.copy(seedB.bounds)); // Right or Bottom most branch
		branchB.addChild(seedB);
		while (children.length > 0)
		{
			var node:RTreeNode<K> = children.pop();
			var branch:RTreeNode<K>;
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

			branch.bounds = RectRegion.expandToCover(branch.bounds, node.bounds);
			branch.addChild(node);
		}

		branchA.hasOnlyLeaves = parent.hasOnlyLeaves;
		branchB.hasOnlyLeaves = parent.hasOnlyLeaves;
		parent.children = new Array();

		if (branchA.children.length == 1 && !branchA.hasOnlyLeaves)
			parent.addChild(branchA.children.pop());
		else
			parent.addChild(branchA);

		if (branchB.children.length == 1 && !branchB.hasOnlyLeaves)
			parent.addChild(branchB.children.pop());
		else
			parent.addChild(branchB);
		parent.hasOnlyLeaves = false;
	}

	public function update(newBounds:RectRegion, value:K):Void
	{
		if (!this.mapper.exists(value))
			return;

		var leaf:RTreeNode<K> = this.mapper.get(value);
		leaf.bounds = newBounds;

		this.updateNodeHierarchy(leaf);
	}

	public function remove(value:K):Void
	{
		if (!this.mapper.exists(value))
			return;

		var leaf:RTreeNode<K> = this.mapper.get(value);
		this.mapper.remove(value);

		var parent:RTreeNode<K> = leaf.parent;
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

			var nextParent:RTreeNode<K> = parent.parent;
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

				var child:RTreeNode<K> = parent.children.pop();
				child.parent = parent.parent;

				parent.parent.hasOnlyLeaves = parent.hasOnlyLeaves;
				parent.parent.children.push(child);

				parent.parent = null;

				parent = child.parent;
			}
			
			if (!parent.hasOnlyLeaves)
			{
				var child:RTreeNode<K> = parent.children[0];
				if (child.children.length == 1)
				{
					parent.children.pop();

					parent.hasOnlyLeaves = child.hasOnlyLeaves;
					parent.addChild(child.children.pop());

					child.parent = null;
				}
			}
		}

		// Rebuild parent's min bounding rect
		parent.recalculateBounds();

		this.updateNodeHierarchy(parent);
	}

	private function updateNodeHierarchy(node:RTreeNode<K>):Void
	{
		var updatedNode:RTreeNode<K> = node;
		var nextParent:RTreeNode<K> = node.parent;

		while (nextParent != null)
		{
			// If we are not intersecting and this parent is not root then attempt to move the node to a better parent
			if ( !Geometry.isRectIntersectingRect(nextParent.bounds, updatedNode.bounds) && nextParent.parent != null)
			{
				var closestParent:RTreeNode<K> = null;
				var closestDistance:Float = Math.POSITIVE_INFINITY;
				var parent:RTreeNode<K>;
				var distance:Float;
				for (parent in nextParent.parent.children)
				{
					// Can't move a leaf to a non-leaf parent
					if (parent.hasOnlyLeaves != nextParent.hasOnlyLeaves)
						continue;

					distance = Math.abs(parent.bounds.left - updatedNode.bounds.left) + Math.abs(parent.bounds.top - updatedNode.bounds.top);
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

					// ASSUME: It's okay to move because we would not have picked a branch that has a different hasOnlyLeaves value
					this.addChildToNode(closestParent, updatedNode);

					// Now ensure that all parents of the new parent expand to fit node
					var currentBranch:RTreeNode<K> = closestParent.parent;
					while (currentBranch != null)
					{
						RectRegion.expandToCover(currentBranch.bounds, updatedNode.bounds);

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

	public function requestKeysIntersectingRect(rect:RectRegion):Array<K>
	{
		if (root == null)
			return [];

		var results:Array<K> = new Array();
		var currentNodes:Array<RTreeNode<K>> = new Array();
		currentNodes.push(this.root);
		var searchNodes:Array<RTreeNode<K>>;

		var continueSearching:Bool = true;
		while (continueSearching)
		{
			searchNodes = new Array();
			while (currentNodes.length > 0)
				searchNodes.push(currentNodes.pop());

			var anyNonLeafs:Bool = false;
			for (node in searchNodes)
			{
				if (!node.hasOnlyLeaves)
					anyNonLeafs = true;

				for (child in node.children)
				{
					if (Geometry.isRectIntersectingRect(rect, child.bounds))
					{
						if (child.isLeaf)
							results.push(child.value);
						else
							currentNodes.push(child);
					}
				}
			}
			continueSearching = anyNonLeafs;
		}

		return results;
	}

	public function requestKeysIntersectingPoint(point:Vector2):Array<K>
	{
		if (root == null)
			return [];

		var results:Array<K> = new Array();
		var currentNodes:Array<RTreeNode<K>> = new Array();
		currentNodes.push(this.root);
		var searchNodes:Array<RTreeNode<K>>;

		var continueSearching:Bool = true;
		while (continueSearching)
		{
			searchNodes = new Array();
			while (currentNodes.length > 0)
				searchNodes.push(currentNodes.pop());

			var anyNonLeafs:Bool = false;
			for (node in searchNodes)
			{
				if (!node.hasOnlyLeaves)
					anyNonLeafs = true;

				for (child in node.children)
				{
					if (child.bounds.isPointInside(point))
					{
						if (child.isLeaf)
							results.push(child.value);
						else
							currentNodes.push(child);
					}
				}
			}
			continueSearching = anyNonLeafs;
		}

		return results;
	}

	/* *
	public function drawDebug()
	{
		if (this.root == null)
			return;

		var canvas:Dynamic = js.Browser.document.getElementById(this.debugCanvas);
		var pen:Dynamic = canvas.getContext2d();

		pen.fillStyle = "#FFFFFF";
		pen.fillRect(0, 0, 1000, 1000);

		pen.strokeStyle = "#000000";

		pen.textAlign = "center";
		pen.textBaseline = "middle";
		pen.font = "20pt Arial";

		var currentNodes:Array<RTreeNode<K>> = new Array();
		var nextNodes:Array<RTreeNode<K>> = new Array();
		nextNodes.push(this.root);

		var node:RTreeNode<K>;
		var level:Int = 0;
		while (nextNodes.length > 0)
		{
			//pen.strokeStyle = colors[level];
			while (nextNodes.length > 0)
				currentNodes.push( nextNodes.pop() );

			while (currentNodes.length > 0)
			{
				node = currentNodes.pop();
				pen.strokeRect(node.bounds.left + debugOffset.left, node.bounds.top + debugOffset.top, node.bounds.width, node.bounds.height);
				pen.strokeText(level+"", node.bounds.left + debugOffset.left + node.bounds.width/2, node.bounds.top + debugOffset.top + node.bounds.height/2);
	
				if (!node.isLeaf)
				{
					for (child in node.children)
					{
						nextNodes.push(child);
					}
				}
			}

			level++;
		}
	}
	/* */
}

class RTreeNode<K>
{
	public var bounds:RectRegion;
	public var value:K;

	public var parent:RTreeNode<K>;
	public var children:Array<RTreeNode<K>>;
	// if true then this only contains leafs as children
	public var hasOnlyLeaves:Bool;
	public var isLeaf:Bool;

	public function new(bounds:RectRegion, ?value:K = null)
	{
		this.bounds = bounds;
		this.children = new Array();
		this.hasOnlyLeaves = false;
		this.isLeaf = (value != null);
		this.value = value;
	}

	public function addChild(node:RTreeNode<K>):Void
	{
		this.children.push(node);
		node.parent = this;
	}

	public function recalculateBounds():Void
	{
		if (this.children.length > 0)
		{
			var newBounds:RectRegion = this.children[0].bounds;
			for (i in 1...this.children.length)
			{
				newBounds = RectRegion.expandToCover(newBounds, this.children[i].bounds);
			}
			this.bounds = newBounds;
		}
	}
}
