document.addEventListener("DOMContentLoaded", function() {

    // Elements
    ///

    // Display settings
    ///

    // Calculation
    var xyzNormalized = {l:0, m:0, s:0};

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
    ///

    // Title
    svgElement.append("text")
        .attr("x", width / 2 - 40)
        .attr("y", -margin.top / 2+30)
        .attr("text-anchor", "middle")
        .style("font-size", "18px")
        .text("XYZ (k)");


    ////////// LMS - Event Handlers //////////

    // Turn on or off the norm path and circles
    function normDisplay(opacity) {
        svgElement.selectAll(".normPath")
            .attr("stroke-opacity", opacity)
        svgElement.selectAll(".normPt")
            .attr("fill-opacity", opacity)
    }

    // Turn on or off the sum bars
    function sumDisplay(opacity) {
        lSumBar.attr("fill-opacity", opacity)
        mSumBar.attr("fill-opacity", opacity)
        sSumBar.attr("fill-opacity", opacity)
    }

    // Update LMS sensitivity based on SPD graph
    setInterval(function() {
        let SPDData = JSON.parse(localStorage.getItem("SPD"));
        if (SPDData == null){
            console.error("SPD Data could not be loaded")
        }
        SPDData.forEach((value, idx)=>{
            /// 

        })
    }, DELAY)

});
