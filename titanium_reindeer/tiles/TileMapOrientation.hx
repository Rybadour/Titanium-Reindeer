package titanium_reindeer.tiles;

/**
 * A way in which a tile map renders it's tiles and rules for adjacency of tiles.
 */
enum TileMapOrientation
{
	// Simple non-rotated grid of tiles.
	// Indexing cells starts at the top-left.
	Orthogonal;

	// Rotated grid of diamond shaped tiles.
	// Indexing cells starts at the top for some styles but at the top-left for most.
	Isometric(style:IsometricStyle);

	Unknown;
}

// See for more info on various isometric styles.
// http://gamedev.stackexchange.com/questions/49847/difference-between-staggered-isometric-and-normal-isometric-tilemaps
/**
 * A specific variation of the isometric orientation.
 */
enum IsometricStyle
{
	// Represents a grid which was basically rotated to the right.
	// Indexing starts at the top. X-axis goes down the right side and Y-axis down the left.
	// Also known as Diamond.
	Normal;

	// Represents a space of cells which follows a non-simple indexing scheme.
	// The space is rotated to the left, so the X-axis goes along the top and the Y-axis zig-zags
	// along the left side. (0, 0) starts at the top-left and follows this scheme every increase in
	// the x-axis is also a decrease in the y-axis.
	Staggered;

	// Represents a grid of cells rotated
	Slide;
}
