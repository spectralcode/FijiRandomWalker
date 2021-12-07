/* This Macro generates a random walker animation as RGB image stack. 
 * To increase the number of frames within the stack you have to change the variable "steps" 
 * 
 * Miroslav Zabic
 * December 2021
 */
 
//input
width = 1920/10;
height = 1080/10;
steps = 900; 
whiteBackground = false;

walkerRed = 255;
walkerGreen = 50;
walkerBlue = 50;

//create new image and initialize walker position and color
imageType = "RGB Black";
colorDelta = 16;
if(whiteBackground){
	imageType = "RGB White";
	colorDelta = -16;
}
newImage("Untitled", imageType, width, height, 1);
x = getWidth()/2;
y = getHeight()/2;
pixelValueWalker = ((walkerRed & 0xff) <<16)+ ((walkerGreen & 0xff) << 8) + (walkerBlue & 0xff);
pixelValueOld = ((255*whiteBackground & 0xff) <<16)+ ((255*whiteBackground & 0xff) << 8) + (255*whiteBackground & 0xff);

//set color of pixel that is visited by walker in this frame to walker color
setPixel(x, y, pixelValueWalker);

copyAndAddFrameToStack();

//start ramdon walk loop	
for (i = 1; i < steps; i++) {
	//remember old position 
	xOld = x;
	yOld = y;

	//create new random walker position
	while(xOld == x && yOld == y){
		x = round(x + 2*random-1);
		y = round(y + 2*random-1);
		//keep walker within image
		x = clamp(0, x, getWidth()-1);
		y = clamp(0, y, getHeight()-1);
	}

	//calculate color of pixel that was was visited by walker in last frame and set color
    r = (pixelValueOld>>16)&0xff + colorDelta; // extract red byte (bits 23-17) and add colorDelta
    g = (pixelValueOld>>8)&0xff + colorDelta ; // extract green byte (bits 15-8) and add colorDelta
    b = pixelValueOld&0xff + colorDelta; // extract blue byte (bits 7-0) and add colorDelta
 	r = clamp(0, r, 255);
 	g = clamp(0, g, 255);
 	b = clamp(0, b, 255);
    pixelValue = ((r & 0xff) <<16) + ((g & 0xff) << 8) + (b & 0xff);
	setPixel(xOld, yOld, pixelValue);

	//remember value of current pixel 
	pixelValueOld = getPixel(x, y);

	//set color of pixel that is visited by walker in this frame to walker color
	setPixel(x, y, pixelValueWalker);

	copyAndAddFrameToStack();
}
run("Delete Slice");

function clamp(lower, value, upper){
    if (value<lower) {
    	value = lower;
    }
    if (value>upper) {
    	value = upper;
    }
    return value;
}

function copyAndAddFrameToStack(){
	run("Copy");
	run("Add Slice");
	run("Paste");
}
