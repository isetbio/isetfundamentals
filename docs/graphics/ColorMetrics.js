document.addEventListener("DOMContentLoaded", function() {
    // Elements
    const colorMetrics = document.getElementById("colorMetrics");
    const colorSample = document.getElementById("colorSample");

    //////////////////// Color Metrics Table ////////////////////

    ////////// CMTable - Create Table //////////

    const cmBody = colorMetrics.getElementsByTagName("tbody")[0].rows[0];

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
