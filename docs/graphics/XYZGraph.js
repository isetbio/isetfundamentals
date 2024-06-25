document.addEventListener("DOMContentLoaded", function() {

    // Elements
    ///

    // Display settings
    ///

    // Calculation
    var xyz = {x:0, x:0, z:0};
    var xyY = {x:0, y:0, Y:0};

    //////////////////// XYZ ////////////////////

    ////////// XYZ - Create GUI //////////

    ///

    ////////// XYZ - Create Static Objects //////////

    // Math Objects
    const x = d3.scaleLinear().domain([400, 700]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([0, 1]).range([graphHeight, 0]);
    const line = d3.line()
        .x(d => x(d.wavelength))
        .y(d => y(d.sensitivity))

    // On-Site (D3) Static Objects
    const svgElement = d3.select(svgXYZ)
        .append("g")
        .attr("transform", `translate(${margin.left},${margin.top})`);

    svgElement.append("g")
        .attr("class", "x axis")
        .attr("transform", `translate(0,${graphHeight})`)
        .call(d3.axisBottom(x));

    svgElement.append("g")
        .attr("class", "y axis")
        .call(d3.axisLeft(y));

    ////////// XYZ - Create Graph Data //////////

    // Sum Bar Data
    ///

    // Fill in

    // Title
    svgElement.append("text")
        .attr("x", width / 2 - 40)
        .attr("y", -margin.top / 2+30)
        .attr("text-anchor", "middle")
        .style("font-size", "18px")
        .text("XYZ (k)");


    ////////// XYZ - Event Handlers //////////


    // Update XYZ based on SPD graph
    setInterval(function() {
        let SPDData = JSON.parse(localStorage.getItem("SPD"));
        if (SPDData == null){
            console.error("SPD Data could not be loaded")
        }
        SPDData.forEach((value, idx)=>{
            // Modify Data
            xyzData[idx].sensitivity = {
                x: xyzMaxData[idx].sensitivity.x * value.intensity,
                y: xyzMaxData[idx].sensitivity.y * value.intensity,
                z: xyzMaxData[idx].sensitivity.z * value.intensity,
            };
            //console.log(JSON.stringify(xyzData[idx].sensitivity));

            // Calculate Sum and Save Data
            let sumX = (total, add)=>total+add.sensitivity.x;
            let sumY = (total, add)=>total+add.sensitivity.y;
            let sumZ = (total, add)=>total+add.sensitivity.z;
            xyz = {
                x: Math.round(xyzData.reduce(sumX, 0)*factorXYZ),
                y: Math.round(xyzData.reduce(sumY, 0)*factorXYZ),
                z: Math.round(xyzData.reduce(sumZ, 0)*factorXYZ)
            }
            let A = xyz.x+xyz.y+xyz.z;
            xyY = {
                x: xyz.x/A,
                y: xyz.y/A,
                Y: xyz.y
            }
            localStorage.setItem("XYZ", JSON.stringify(xyz));
            localStorage.setItem("xyY", JSON.stringify(xyY));

        })
    }, DELAY)

});
