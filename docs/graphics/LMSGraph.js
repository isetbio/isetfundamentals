document.addEventListener("DOMContentLoaded", function() {
    //
    console.log("Loaded: LMS")

    // Elements
    const svg = document.getElementById("lmsGraph");

    // Size settings
    const width = svg.clientWidth;
    const height = svg.clientHeight;
    const margin = {top: 20, right: 30, bottom: 30, left: 40};
    const graphWidth = width - margin.left - margin.right;
    const graphHeight = height - margin.top - margin.bottom;

    //////////////////// LMS ////////////////////

    ////////// LMS - Create Static Objects //////////

    // Math Objects
    const x = d3.scaleLinear().domain([400, 700]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([0, 1]).range([graphHeight, 0]);
    const line = d3.line()
        .x(d => x(d.wavelength))
        .y(d => y(d.sensitivity))

    // On-Site (D3) Static Objects
    const svgElement = d3.select(svg)
        .append("g")
        .attr("transform", `translate(${margin.left},${margin.top})`);

    svgElement.append("g")
        .attr("class", "x axis")
        .attr("transform", `translate(0,${graphHeight})`)
        .call(d3.axisBottom(x));

    svgElement.append("g")
        .attr("class", "y axis")
        .call(d3.axisLeft(y));

    ////////// LMS - Create Graph Data //////////

    // Fill in
    var lMaxData, mMaxData, sMaxData, lData, mData, sData;

    SPD2LMS_load().then(resolved => {
        console.log("...")
        lMaxData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: parseFloat(SPD2LMS(MINWV + i * STEPWV).l)}));
        mMaxData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: parseFloat(SPD2LMS(MINWV + i * STEPWV).m)}));
        sMaxData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: parseFloat(SPD2LMS(MINWV + i * STEPWV).s)}));
        lData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: 0}));
        mData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: 0}));
        sData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: 0}));
        console.log(lMaxData);
    }).catch(rejected=>{
        console.error(rejected);
    });


    // On-Site (D3) Dynamic Objects
    const lMaxPath = svgElement.append("path")
        .datum(lMaxData)
        .attr("class", "line")
        .attr("d", line)
        .attr("fill-opacity", 0)
        .attr("stroke", "red")
        .attr("stroke-opacity", 0.5)
        .attr("stroke-width", 2);
    
    /*const mMaxPath = svgElement.append("path")
        .datum(mMaxData)
        .attr("class", "line")
        .attr("d", line)
        .attr("fill-opacity", 0)
        .attr("stroke", "green")
        .attr("stroke-opacity", 0.5)
        .attr("stroke-width", 2);

    const sMaxPath = svgElement.append("path")
        .datum(sMaxData)
        .attr("class", "line")
        .attr("d", line)
        .attr("fill-opacity", 0)
        .attr("stroke", "blue")
        .attr("stroke-opacity", 0.5)
        .attr("stroke-width", 2);*/

    svgElement.selectAll(".lMax")
        .data(lMaxData)
        .enter().append("circle")
        .attr("r", 5)
        .attr("cx", d => x(d.wavelength))
        .attr("cy", d => y(d.sensitivity))
        .attr("fill", "red")
        .attr("fill-opacity", 0.5)

    /*svgElement.selectAll(".mMax")
        .data(mMaxData)
        .enter().append("circle")
        .attr("r", 5)
        .attr("cx", d => x(d.wavelength))
        .attr("cy", d => y(d.sensitivity))
        .attr("fill", "green")
        .attr("fill-opacity", 0.5)

    svgElement.selectAll(".sMax")
        .data(sMaxData)
        .enter().append("circle")
        .attr("r", 5)
        .attr("cx", d => x(d.wavelength))
        .attr("cy", d => y(d.sensitivity))
        .attr("fill", "blue")
        .attr("fill-opacity", 0.5)*/
    
    svgElement.selectAll("circle")
        .on("mouseover", function(event, d) {
            d3.select(this).transition()
                .duration(50)
                .attr("r", 8); // Magnify the circle
        })
        .on("mouseout", function(event, d) {
            d3.select(this).transition()
                .duration(100)
                .attr("r", 5); // Reset the circle size
        });
    
    svgElement.append("text")
        .attr("x", width / 2 - 40)
        .attr("y", -margin.top / 2+30)
        .attr("text-anchor", "middle")
        .style("font-size", "18px")
        .text("LMS Sensitivity Levels");


    ////////// LMS - Event Handlers //////////
    

});
