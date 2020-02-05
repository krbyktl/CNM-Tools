//for RGC counting


imageTitle=getTitle()
run("Split Channels")
//Subtract background of DAPI image
	i="C2-";
    selectWindow(i+imageTitle); 
    run("Duplicate...", " ");
    run("Gaussian Blur...", "sigma=50");
    blurTitle=getTitle();
    imageCalculator("Subtract", blurTitle, i+imageTitle);
    close(blurTitle);
//Subtract background of RBPMS image
	j="C1-";
    selectWindow(j+imageTitle); 
    run("Duplicate...", " ");
    run("Gaussian Blur...", "sigma=50");
    blurTitle=getTitle();
    imageCalculator("Subtract", blurTitle, j+imageTitle);
    close(blurTitle);
//Add RBPMS regions to manager
	selectWindow(j+imageTitle);
	run("Morphological Filters", "operation=Closing element=Disk radius=10");
	setAutoThreshold("Triangle dark");
	run("Threshold...");
	run("Analyze Particles...", "size=40-Infinity circularity=0.00-inf show=Masks display include add");
//Combine ROI selections
	a=roiManager("count");
	b=Array.getSequence(a);
	c=Array.slice(b, 0);
	if (roiManager("count")==0){
		RBPMS = 0;
	}
	else { 
		if (roiManager("count")==1){
			roiManager("Select", 0);
		}else{
			roiManager("Select", c);
			roiManager("Combine");
			roiManager("Add");
			roiManager("Select", c);
			roiManager("Delete");
		}
	}
//count DAPI with combined ROI overlay
	selectWindow(i+imageTitle);
	run("Morphological Filters", "operation=Closing element=Disk radius=10");
	setAutoThreshold("Mean dark");
	run("Convert to Mask");
	run("Watershed");
	if (roiManager("count")>=1){
		roiManager("Select", 0);
		run("Analyze Particles...", "size=20-Infinity circularity=0.00-inf show=Masks display include add");
	}
//Save data
	if (roiManager("count")>=1){
		RBPMS = roiManager("count")-1;
		roiManager("Delete");
	}
	else{
		RBPMS = 0;
	}
//Record data in table
	name = "[Cell Count]";
	f=name;
	if (isOpen("Cell Count")){
   		print(f, imageTitle +":");
		print(f, "RBPMS+ cells: "+ RBPMS);
	}
	else {
   		run("New... ", "name="+f+" type=Table");
   		print(f, imageTitle +":");
		print(f, "RBPMS+ cells: "+ RBPMS);
	}
	if (roiManager("count")>=1) {
		roiManager("Delete");
	}
macro "Close All Windows" { 
    while (nImages>0) { 
         selectImage(nImages); 
         close(); 
      } 
  } 
