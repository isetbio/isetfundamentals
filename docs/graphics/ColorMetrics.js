document.addEventListener("DOMContentLoaded", function() {
    //
    console.log("Loaded: ColorMetrics")

    // Elements
    const colorMetrics = document.getElementById("colorMetrics");

    //////////////////// Color Metrics Table ////////////////////

    ////////// CMTable - Create Table //////////

    const cmBody = colorMetrics.getElementsByTagName("tbody")[0].rows[1];

    const LMSValue = cmBody.cells[0];
    const RGBValue = cmBody.cells[1];

    ////////// CMTable - Set Update Interval //////////

    
    setInterval(function() {
            let RGB = JSON.parse(localStorage.getItem("RGB"));
            if (RGB != null){
                RGBValue.innerHTML = `(${RGB.r}, ${RGB.g}, ${RGB.b})`;
            }
        }, 10)
    
    


    
});
