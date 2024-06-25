document.addEventListener("DOMContentLoaded", function() {

    // Elements
    const checkpointSwitch = document.getElementById('CheckpointSwitch');
    const sumSwitch = document.getElementById('SumSwitch');
    const csRadio = document.getElementById('csRadio');

    // Display settings
    const opacityForMax = 0.5;
    const opacityForNorm = 0.1;
    const opacityForSum = 1.0;
    const rectWidth = 30; // in graph X units

    // Calculation
    var colorStandard = [0, 0, 0]
    var colorNormalized = [0, 0, 0]
    var space = 0;

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

    csRadio.addEventListener('click', function() {
        // Get all radio buttons
        const radios = document.querySelectorAll('input[name="csRadio"]');
        // Find the checked radio button
        for (const radio of radios) {
          if (radio.checked) {
            space = radio.value;
            resetDisplay();
            break;
          }
        }
      });

    ////////// Create Static Objects //////////

    // Math Objects
    const x = d3.scaleLinear().domain([400, 700]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([-0.5, 3]).range([graphHeight, 0]);
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
        .attr("transform", `translate(${margin.left},${margin.top})`)
        .call(d3.zoom().on("zoom", function () {
            svg.attr("transform", d3.event.transform)
        }))

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
        .attr("stroke", "black")
        .attr("stroke-width", 2)

    svgElement.append('g')
        .attr('class', 'x axis-grid')
        .attr('transform', 'translate(0,' + graphHeight + ')')
        .call(d3.axisBottom(x).tickSize(-graphHeight).tickFormat('').ticks(29));
    svgElement.append('g')
        .attr('class', 'y axis-grid')
        .call(d3.axisLeft(y).tickSize(-graphWidth).tickFormat('').ticks(11));


    ////////// Create Graph Data //////////

    // Initialize current v max sensitivity data
    var maxData;
    var data;

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
        svgElement.selectAll(".path")
            .attr("stroke-opacity", opacity)
        svgElement.selectAll(".cp")
            .attr("fill-opacity", opacity)
    }

    // Turn on or off the sum bars
    function sumDisplay(opacity) {
        for (let bar = 0; bar < 3; bar++){
            sumBar[bar].attr("fill-opacity", opacity)
        }
    }

    // Initialize
    function setUpDisplay() {
        maxData = Array.from({length: NUMWV}, (v, i) => ({
            wavelength: MINWV + i * STEPWV, 
            sensitivity: SPD2(MINWV + i * STEPWV, space, use_factor=false)
        }))
        data = Array.from({length: NUMWV}, (v, i) => ({
            wavelength: MINWV + i * STEPWV, 
            sensitivity: {a:0, b:0, c:0}
        }));

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
        maxData = Array.from({length: NUMWV}, (v, i) => ({
            wavelength: MINWV + i * STEPWV, 
            sensitivity: SPD2(MINWV + i * STEPWV, space, use_factor=false)
        }))

        for (let bar = 0; bar < 3; bar++) {
            let T = 'abc'[bar];

            // Assign right max path
            maxPath[bar]
                .datum(maxData)
                .attr("stroke", COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])
                .attr("d", line[bar])
            
            // Assign right path
            path[bar]
                .datum(data)
                .attr("stroke", COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])
                .attr("d", line[bar])

            // Assign checkpoints
            svgElement.selectAll(".cp"+bar)
                .data(data)
                .attr("cy", d => y(d.sensitivity[T]))
                .attr('fill', COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])
            
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
            let standard = COLORSPACEINFO[COLORSPACES[space]].standard;
            let sumA = (total, add)=>total+add.sensitivity.a;
            let sumB = (total, add)=>total+add.sensitivity.b;
            let sumC = (total, add)=>total+add.sensitivity.c;
            colorStandard = { // from color space specific
                a: Math.round(ROUNDING*data.reduce(sumA, 0)*factor*standard[0]/norm[0])/ROUNDING,
                b: Math.round(ROUNDING*data.reduce(sumB, 0)*factor*standard[1]/norm[1])/ROUNDING,
                c: Math.round(ROUNDING*data.reduce(sumC, 0)*factor*standard[2]/norm[2])/ROUNDING
            }
            colorNormalized = { // from [0, 1]
                a: Math.round(ROUNDING*data.reduce(sumA, 0)*factor/norm[0])/ROUNDING,
                b: Math.round(ROUNDING*data.reduce(sumB, 0)*factor/norm[1])/ROUNDING,
                c: Math.round(ROUNDING*data.reduce(sumC, 0)*factor/norm[2])/ROUNDING
            }
            localStorage.setItem(COLORSPACES[space]+"Standard", JSON.stringify(colorStandard));
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
                sumBar[bar]
                    .attr("height", Math.abs(y(0)-y(colorNormalized[T])))
                    .attr("y", Math.min(y(0), y(colorNormalized[T])))
            }

        })
    }, DELAY)

});
