document.addEventListener("DOMContentLoaded", function() {
    //
    console.log("Loaded: ColorMetrics")

    // Elements
    const colorMetrics = document.getElementById("colorMetrics");

    //////////////////// Color Metrics Table ////////////////////

    ////////// CMTable - Create Table //////////

    const cmBody = colorMetrics.getElementsByTagName("tbody")[0].rows[0];

    const LMSValue = cmBody.cells[0];
    const LMSCVDValue = cmBody.cells[1];
    const RGBValue = cmBody.cells[2];
    const RGBCVDValue = cmBody.cells[3];
    const XYZValue = cmBody.cells[4];

    ////////// CMTable - Set Update Interval //////////

    
    setInterval(function() {
        // LMS Update
        let LMS = JSON.parse(localStorage.getItem("LMSNorm"));
        if (LMS != null){
            LMSValue.innerHTML = `(${LMS.a}, ${LMS.b}, ${LMS.c})`;
        }
        // LMS CVD Update
        let LMSCVD = JSON.parse(localStorage.getItem("LMSCVDNorm"));
        if (LMSCVD != null){
            LMSCVDValue.innerHTML = `(${LMSCVD.a}, ${LMSCVD.b}, ${LMSCVD.c})`;
        }
        // RGB Update
        let RGB = JSON.parse(localStorage.getItem("RGBStandard"));
        if (RGB != null){
            RGBValue.innerHTML = `(${RGB[0]}, ${RGB[1]}, ${RGB[2]})`;
        }
        // RGB CVD Update
        let RGBCVD = JSON.parse(localStorage.getItem("RGBCVDStandard"));
        if (RGBCVD != null){
            RGBCVDValue.innerHTML = `(${RGBCVD[0]}, ${RGBCVD[1]}, ${RGBCVD[2]})`;
        }

        // XYZ Update
        let XYZ = JSON.parse(localStorage.getItem("XYZStandard"));
        if (XYZ != null){
            XYZValue.innerHTML = `(${XYZ[0]}, ${XYZ[1]}, ${XYZ[2]})`;
        }

    }, DELAY)
    
    


    
});
