document.addEventListener("DOMContentLoaded", function() {

    // Elements
    ///

    // Display settings
    ///

    // Calculation
    var xyY = {x:0, y:0, Y:0};

    //////////////////// XYZ ////////////////////

    ////////// XYZ - Create GUI //////////

    ///

    ////////// XYZ - Create Static Objects //////////

    // Math Objects
    const x = d3.scaleLinear().domain([0, 1]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([0, 1]).range([graphHeight, 0]);
    const line = d3.line()
        .x(d => x(d.x))
        .y(d => y(d.y))

    // On-Site (D3) Static Objects
    const svgElement = d3.select(svgChromaticity)
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

    // Path
    var data = Array.from({length: 471}, (v, i) => ({x: chromaData[i].x, y: chromaData[i].y}));
    const path = svgElement.append("path")
        .datum(data)
        .attr("class", "line")
        .attr("d", line)
        .attr("fill-opacity", 0)
        .attr("stroke", "red")
        .attr("stroke-width", 2);

    // Color Point
    var coords = {x: 0, y: 0};
    const colorPoint = svgElement.append("circle")
        .attr("class", "colorPoint")
        .attr("r", 5)
        .attr("fill", "blue")
    
    // Color Point
    const D65Point = svgElement.append("circle")
        .attr("class", "specialPoint")
        .attr("id", "D65Point")
        .attr("r", 5)
        .attr("fill", "white")
        .attr("stroke", "black")
        .attr("stroke-width", 1)
        .attr("cx", x(0.33328))
        .attr("cy", x(0.33359))

    // Title
    svgElement.append("text")
        .attr("x", titleX)
        .attr("y", titleY)
        .attr("text-anchor", "middle")
        .style("font-size", "22px")
        .text("XYZ (k)");

    // Axis Labels
    svgElement.append("text")
        .attr("class", "x label")
        .attr("text-anchor", "middle")
        .attr("x", XLabelX)
        .attr("y", XLabelY)
        .text("x");
    
    svgElement.append("text")
        .attr("class", "y label")
        .attr("text-anchor", "middle")
        .attr("y", YLabelY)
        .attr("x", YLabelX)
        .text("y")
        .attr("transform", "rotate(-90)")


    ////////// XYZ - Event Handlers //////////


    // Update XYZ based on SPD graph
    setInterval(function() {
        let {a, b, c} = JSON.parse(localStorage.getItem("XYZNorm"));
        coords.x = a/(a+b+c)
        coords.y = b/(a+b+c)
        colorPoint.attr("cx",x(coords.x)).attr("cy",y(coords.y))
    }, DELAY)

});
