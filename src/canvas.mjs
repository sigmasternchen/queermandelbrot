
export const getContext = (id) => 
	document.getElementById(id).getContext("2d");

export const getInnerWidth = () =>
	window.innerWidth;

export const getInnerHeight = () =>
	window.innerHeight;

export const onResize = (callback) => 
	window.addEventListener("resize", callback);

export const setPixel = (ctx, x, y, color) => {
	ctx.fillStyle = color;
	ctx.fillRect(x, y, 1, 1);
};

export const clear = (ctx) => {
	ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
};

export const setSize = (ctx, width, height) => {
	ctx.canvas.width = width;
	ctx.canvas.height = height;
};

export const requestAnimationFrame = (callback) => {
	let eventListener = () => {
		callback();
		window.removeEventListener("message", eventListener);
	}

	window.addEventListener("message", eventListener)
	window.postMessage(null);
};
//window.requestAnimationFrame;
