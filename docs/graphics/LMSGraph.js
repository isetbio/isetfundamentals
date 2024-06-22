document.addEventListener("DOMContentLoaded", function() {

    // Elements
    const svg = document.getElementById("lmsGraph");

    // Size settings
    const width = svg.clientWidth;
    const height = svg.clientHeight;
    const margin = {top: 20, right: 30, bottom: 30, left: 40};
    const graphWidth = width - margin.left - margin.right;
    const graphHeight = height - margin.top - margin.bottom;

    // Display settings
    const opacityForMax = 0.3;

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

    SPD2LMS_load()
    lMaxData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: parseFloat(SPD2LMS(MINWV + i * STEPWV).l)}));
    mMaxData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: parseFloat(SPD2LMS(MINWV + i * STEPWV).m)}));
    sMaxData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: parseFloat(SPD2LMS(MINWV + i * STEPWV).s)}));
    lData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: 0.1}));
    mData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: 0.2}));
    sData = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, sensitivity: 0.3}));

    // Max Path Individual data
    const lMaxPath = svgElement.append("path")
        .datum(lMaxData)
        .attr("class", "maxPath")
        .attr("stroke", "red")
        .attr("fill", "red")
        .attr("d", line)
    
    const mMaxPath = svgElement.append("path")
        .datum(mMaxData)
        .attr("class", "maxPath")
        .attr("stroke", "green")
        .attr("fill", "green")
        .attr("d", line)

    const sMaxPath = svgElement.append("path")
        .datum(sMaxData)
        .attr("class", "maxPath")
        .attr("stroke", "blue")
        .attr("fill", "blue")
        .attr("d", line)
    
    // Norm Path Individual data
    const lPath = svgElement.append("path")
        .datum(lData)
        .attr("class", "normPath")
        .attr("stroke", "red")
        .attr("d", line)
    
    const mPath = svgElement.append("path")
        .datum(mData)
        .attr("class", "normPath")
        .attr("stroke", "green")
        .attr("d", line)

    const sPath = svgElement.append("path")
        .datum(sData)
        .attr("class", "normPath")
        .attr("stroke", "blue")
        .attr("d", line)
    
    svgElement.selectAll(".lNorm")
        .data(lData)
        .enter().append("circle")
        .attr("class", "normPt lNorm")
        .attr("fill", "red")

    svgElement.selectAll(".mNorm")
        .data(mData)
        .enter().append("circle")
        .attr("class", "normPt mNorm")
        .attr("fill", "green")

    svgElement.selectAll(".sNorm")
        .data(sData)
        .enter().append("circle")
        .attr("class", "normPt sNorm")
        .attr("fill", "blue")
    
    // Group Data
    svgElement.selectAll("path")
        .attr("stroke-width", 2);

    svgElement.selectAll(".maxPath")
        .attr("stroke-opacity", opacityForMax)
        .attr("fill-opacity", 0)
    
    svgElement.selectAll(".normPath")
        .attr("stroke-opacity", 1)
        .attr("fill-opacity", 0)

    svgElement.selectAll(".normPt")
        .attr("stroke-opacity", 1)
        .attr("fill-opacity", 1)
        .attr("r", 5)
        .attr("cx", d => x(d.wavelength))
        .attr("cy", d => y(d.sensitivity))
    
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
        .text("LMS Spectral Sensitivity (k)");


    ////////// LMS - Event Handlers //////////

    // Update LMS sensitivity based on SPD graph
    setInterval(function() {
        let SPDData = JSON.parse(localStorage.getItem("SPD"));
        if (SPDData == null){
            console.error("SPD Data could not be loaded")
        }
        SPDData.forEach((value, idx)=>{
            // Modify Data
            lData[idx].sensitivity = lMaxData[idx].sensitivity * value.intensity;
            mData[idx].sensitivity = mMaxData[idx].sensitivity * value.intensity;
            sData[idx].sensitivity = sMaxData[idx].sensitivity * value.intensity;

            // Display Data
            svgElement.selectAll(".lNorm")
                .filter((_, i) => idx === i)
                .attr("cy", y(lData[idx].sensitivity));
            
            svgElement.selectAll(".mNorm")
                .filter((_, i) => idx === i)
                .attr("cy", y(mData[idx].sensitivity));
            
            svgElement.selectAll(".sNorm")
                .filter((_, i) => idx === i)
                .attr("cy", y(sData[idx].sensitivity));
            
            lPath.attr("d", line);
            mPath.attr("d", line);
            sPath.attr("d", line);

            // Calculate Sum and Save Data
            let sum = (total, add)=>total+add.sensitivity;
            var lms = {
                l: Math.round(lData.reduce(sum, 0)*factorLMS), 
                m: Math.round(mData.reduce(sum, 0)*factorLMS), 
                s: Math.round(sData.reduce(sum, 0)*factorLMS)
            };
            localStorage.setItem("LMS", JSON.stringify(lms));
        })
    }, DELAY)

});
