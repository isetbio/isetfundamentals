document.addEventListener("DOMContentLoaded", function() {

    // Elements
    const checkpointSwitch = document.getElementById('CheckpointSwitch');
    const sumSwitch = document.getElementById('SumSwitch');

    // Display settings
    const opacityForMax = 0.3;
    const opacityForNorm = 0.3;
    const opacityForSum = 1.0;
    const rectWidth = 30; // in graph X units

    // Calculation
    var color = [0, 0, 0]
    var colorNormalized = [0, 0, 0]
    var space = 2;

    //////////////////// Main ////////////////////

    ////////// Create GUI //////////

    checkpointSwitch.addEventListener('change', (event) => {
        if (event.target.checked) {
            normDisplay(opacityForNorm);
        } else {
            normDisplay(0);
        }
    });
    sumSwitch.addEventListener('change', (event) => {
        if (event.target.checked) {
            sumDisplay(opacityForSum);
        } else {
            sumDisplay(0);
        }
    });

    ////////// Create Static Objects //////////

    // Math Objects
    const x = d3.scaleLinear().domain([400, 700]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([-0.3, 2]).range([graphHeight, 0]);
    const line = [
        d3.line()
            .x(d => x(d.wavelength))
            .y(d => y(d.sensitivity.a)),
        d3.line()
            .x(d => x(d.wavelength))
            .y(d => y(d.sensitivity.b)),
        d3.line()
            .x(d => x(d.wavelength))
            .y(d => y(d.sensitivity.c))
    ]

    // On-Site (D3) Static Objects
    const svgElement = d3.select(svgSensitivity)
        .append("g")
        .attr("transform", `translate(${margin.left},${margin.top})`);

    svgElement.append("g")
        .attr("class", "x axis")
        .attr("transform", `translate(0,${graphHeight})`)
        .call(d3.axisBottom(x));

    svgElement.append("g")
        .attr("class", "y axis")
        .call(d3.axisLeft(y))

    svgElement.append("line")
        .attr("id", "stability-line")
        .attr("x1", x(400))
        .attr("y1", y(0))
        .attr("x2", x(700))
        .attr("y2", y(0))
        .attr("fill", "black")
        

    ////////// Create Graph Data //////////

    // Initialize current v max sensitivity data
    var maxData, data;
    maxData = Array.from({length: NUMWV}, (v, i) => ({
        wavelength: MINWV + i * STEPWV, 
        sensitivity: SPD2(MINWV + i * STEPWV, space)
    }));
    data = Array.from({length: NUMWV}, (v, i) => ({
        wavelength: MINWV + i * STEPWV, 
        sensitivity: {a:0, b:0, c:0}
    }));

    // Display arrays
    const maxPath = [];
    const path = [];
    const sumBar = [];
    
    // Fix Up Data
    setUpDisplay();

    // Title
    svgElement.append("text")
        .attr("x", width / 2 - 40)
        .attr("y", -margin.top / 2+30)
        .attr("text-anchor", "middle")
        .style("font-size", "18px")
        .text("Spectral Sensitivity (k)");

    ////////// Event Handlers //////////

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

    // Initialize
    function setUpDisplay() {
        for (let bar = 0; bar < 3; bar++) {
            let T = 'abc'[bar];
            // Fix Max Path: a, b, c

            // Assign right max path
            maxPath.push(
                svgElement.append("path")
                    .datum(maxData)
                    .attr("class", "maxPath")
                    .attr("stroke", COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])
                    .attr("d", line[bar]))
            
            // Assign right path
            path.push(
                svgElement.append("path")
                    .datum(data)
                    .attr("class", "path")
                    .attr("stroke", COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])
                    .attr("d", line[bar]))

            // Assign checkpoints
            svgElement.selectAll(".cp"+bar)
                .data(data)
                .enter().append("circle")
                .attr("class", "cp cp"+bar)
                .attr("cx", d => x(d.wavelength))
                .attr("cy", d => y(d.sensitivity[T]))
                .attr('fill', COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])

            // Assign sum bars
            sumBar.push(svgElement.append("rect")
                .attr('x', x(COLORSPACEINFO[COLORSPACES[space]].rectLoc[bar]))
                .attr('y', 0)
                .attr('width', x(rectWidth)-x(0))
                .attr('height', 0)
                .attr('fill', COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar]))
        }

        svgElement.selectAll("path")
            .attr("stroke-width", 2);

        svgElement.selectAll(".maxPath")
            .attr("stroke-opacity", opacityForMax)
            .attr("fill-opacity", 0)
        
        svgElement.selectAll(".path")
            .attr("stroke-opacity", opacityForNorm)
            .attr("fill-opacity", 0)
        
        svgElement.selectAll(".cp")
            .attr("fill-opacity", opacityForNorm)
            .attr("r", 5)
        
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
    }

    // Reinitialize when changing color space
    function resetDisplay() {
        for (let bar = 0; bar < 3; bar++) {
            let T = 'abc'[bar];

            // Assign right max path
            maxPath[bar]
                //.datum(maxData)
                .attr("stroke", COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])
            
            // Assign right path
            path[bar]
                //.datum(data)
                .attr("stroke", COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])

            // Assign checkpoints
            svgElement.selectAll(".cp"+bar)
                //.data(data)
            
            // Assign sum bars
            sumBar[bar]
                .attr('x', x(COLORSPACEINFO[COLORSPACES[space]].rectLoc[bar]))
                .attr('fill', COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])
        }
    }

    // Update sensitivity based on SPD graph
    setInterval(function() {
        let SPDData = JSON.parse(localStorage.getItem("SPD"));
        if (SPDData == null){
            console.error("SPD Data could not be loaded")
        }
        SPDData.forEach((value, idx)=>{
            // Modify Data
            data[idx].sensitivity = {
                a: maxData[idx].sensitivity.a * value.intensity,
                b: maxData[idx].sensitivity.b * value.intensity,
                c: maxData[idx].sensitivity.c * value.intensity,
            }

            // Calculate Sum and Save Data
            let factor = COLORSPACEINFO[COLORSPACES[space]].factor;
            let norm = COLORSPACEINFO[COLORSPACES[space]].norm;
            let sumA = (total, add)=>total+add.sensitivity.a;
            let sumB = (total, add)=>total+add.sensitivity.b;
            let sumC = (total, add)=>total+add.sensitivity.c;
            color = {
                a: Math.round(data.reduce(sumA, 0)*factor),
                b: Math.round(data.reduce(sumB, 0)*factor),
                c: Math.round(data.reduce(sumC, 0)*factor)
            }
            colorNormalized = {
                a: Math.round(ROUNDING*data.reduce(sumA, 0)*factor/norm[0])/ROUNDING,
                b: Math.round(ROUNDING*data.reduce(sumB, 0)*factor/norm[1])/ROUNDING,
                c: Math.round(ROUNDING*data.reduce(sumC, 0)*factor/norm[2])/ROUNDING
            }
            localStorage.setItem(COLORSPACES[space], JSON.stringify(color));
            localStorage.setItem(COLORSPACES[space]+"Norm", JSON.stringify(colorNormalized));

            // Display New Data
            for (let bar = 0; bar < 3; bar++){
                let T = 'abc'[bar];
                // CP Nodes
                svgElement.selectAll(".cp"+bar)
                    .filter((_, i) => idx === i)
                    .attr("cy", y(data[idx].sensitivity[T]));
                // CP Path
                path[bar].attr("d", line[bar]);
                // Sum Bar
                sumBar[bar].attr("height", y(0)-y(colorNormalized[T])).attr("y", y(colorNormalized[T]))
            }

        })
    }, DELAY)

});
