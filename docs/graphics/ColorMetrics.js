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
        }, 500)
    
    
      

    /**
     * 
     * <table id="colorMetrics">
                <thead>
                    <tr>
                        <th>RGB Color</th>
                        <th>LMS Color</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>...</td>
                        <td>...</td>
                    </tr>
                </tbody>
            </table>
     */



    
});
