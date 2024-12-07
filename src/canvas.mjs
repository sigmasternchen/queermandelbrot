
export const getContext = (id) => 
	document.getElementById(id).getContext("2d");

export const setPixel = (ctx, x, y, color) => {
	ctx.fillStyle = color;
	ctx.fillRect(x, y, 1, 1);
};
