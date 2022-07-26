//Generate two copies of the image
//run("Clear", "slice");
run("Duplicate...", "title=I1 duplicate");
run("Duplicate...", "title=I2 duplicate");
run("Duplicate...", "title=I3 duplicate");

inputId = getImageID(); // gets active image 
inputTitle = getTitle(); 

Stack.getDimensions(width, height, channels, slices, frames); 

for (i=1; i<frames+1; i++){ 
        Stack.setFrame(i); 
        for (j=1; j<slices+1; j++) { 
                Stack.setSlice(j); 
                run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None*"); 
        } 
}

run("Make Binary", "method=Huang background=Default calculate")
//run("Fill Holes", "stack");
//run("Analyze Particles...", "size=50-Infinity show=Outlines display add in_situ stack");
run("Analyze Particles...", "size=50-Infinity show=Outlines display add in_situ stack");
run("Clear Results");
selectWindow("I1");
run("From ROI Manager");
run("Set Measurements...", "area mean min perimeter integrated redirect=None decimal=3");
roiManager("Measure");
selectWindow("I2");

inputId2 = getImageID(); // gets active image 
inputTitle2 = getTitle(); 

Stack.getDimensions(width, height, channels, slices, frames); 

        for (l=0; l<frames; l++) { 
                Stack.setSlice(l); 
                roiManager("Select", l);
                run("Fill", "slice"); 
        } 
        
setTool("rectangle");
run("Select All");

selectWindow("I2");
run("Make Binary", "method=Huang background=Default calculate")
run("Erode", "stack");
run("Dilate", "stack");

run("Find Edges", "stack");


selectWindow("I2");

inputId = getImageID(); // gets active image 
inputTitle = getTitle(); 

Stack.getDimensions(width, height, channels, slices, frames); 

        for (m=1; m<frames+1; m++) { 
                setSlice(m); 
                run("Measure");
        } 