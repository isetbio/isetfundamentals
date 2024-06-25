document.addEventListener("DOMContentLoaded", function() {
    //
    console.log("Loaded: ColorMetrics")

    // Elements
    const colorMetrics = document.getElementById("colorMetrics");

    //////////////////// Color Metrics Table ////////////////////

    ////////// CMTable - Create Table //////////

    const cmBody = colorMetrics.getElementsByTagName("tbody")[0].rows[0];

    const LMSValue = cmBody.cells[0];
    const RGBValue = cmBody.cells[1];
    const XYZValue = cmBody.cells[2];

    ////////// CMTable - Set Update Interval //////////

    
    setInterval(function() {
        // RGB Update
        let RGB = JSON.parse(localStorage.getItem("RGB"));
        if (RGB != null){
            RGBValue.innerHTML = `(${RGB.a}, ${RGB.b}, ${RGB.c})`;
        }

        // LMS Update
        let LMS = JSON.parse(localStorage.getItem("LMS"));
        if (LMS != null){
            LMSValue.innerHTML = `(${LMS.a}, ${LMS.b}, ${LMS.c})`;
        }

        // XYZ Update
        let XYZ = JSON.parse(localStorage.getItem("XYZ"));
        if (XYZ != null){
            XYZValue.innerHTML = `(${XYZ.a}, ${XYZ.b}, ${XYZ.c})`;
        }

    }, DELAY)
    
    


    
});
