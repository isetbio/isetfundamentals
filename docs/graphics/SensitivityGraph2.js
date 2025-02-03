import { multiply } from 'https://cdn.jsdelivr.net/npm/mathjs@11.5.1/+esm';
document.addEventListener("DOMContentLoaded", function() {

    // Elements
    const checkpointSwitch = document.getElementById('CheckpointSwitch');
    const sumSwitch = document.getElementById('SumSwitch');

    // Display settings
    const opacityForMax = 0.5;
    const opacityForNorm = 0.2;
    const opacityForSum = 1.0;
    const rectWidth = 30; // in graph X units

    // Calculation
    var colorStandard = [0, 0, 0]
    var colorNormalized = [0, 0, 0]
    var space = 0;
    var shifts = [0, 0, 0];

    //////////////////// Main ////////////////////

    ////////// Create Switch elements //////////

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

    ////////// Create Severity Slider elements //////////

    var sliderwidth = '125px';

    // Set the dimensions of the slider
    var sliderL = d3.select('#sliderL')
        .append('input')
        .attr('type', 'range')
        .attr('min', 0)
        .attr('max', 1)
        .attr('value', 0) // Initial value
        .attr('step', 0.01)
        .style('width', sliderwidth)
        .on('input', function() {
            shifts[0] = this.value * LMSSHIFTINFO.L.maxShift;
            d3.select('#valueL').text('L Cone Shift: ' + this.value);
            updateShifts();
        });
    var sliderM = d3.select('#sliderM')
        .append('input')
        .attr('type', 'range')
        .attr('min', 0)
        .attr('max', 1)
        .attr('value', 0) // Initial value
        .attr('step', 0.01)
        .style('width', sliderwidth)
        .on('input', function() {
            shifts[1] = this.value * LMSSHIFTINFO.M.maxShift;
            d3.select('#valueM').text('M Cone Shift: ' + this.value);
            updateShifts();
        });
    var sliderS = d3.select('#sliderS')
        .append('input')
        .attr('type', 'range')
        .attr('min', 0)
        .attr('max', 1)
        .attr('value', 0) // Initial value
        .attr('step', 0.01)
        .style('width', sliderwidth)
        .on('input', function() {
            shifts[2] = this.value * LMSSHIFTINFO.S.maxShift;
            d3.select('#valueS').text('S Cone Shift: ' + this.value);
            updateShifts();
        });

    function updateShifts () {
        console.log("updated", shifts)
        for (let bar = 0; bar < 3; bar++){
            let T = 'abc'[bar];
            // Max Path
            maxPath[bar].attr("d", lineWithShift[bar]);
            // CP Path
            path[bar].attr("d", lineWithShift[bar]);
            // Sum Bar
            sumBar[bar]
                .attr("height", Math.abs(y(0)-y(colorNormalized[T])))
                .attr("y", Math.min(y(0), y(colorNormalized[T])))
        }
        maxData = Array.from({length: NUMWV}, (v, i) => ({
                wavelength: MINWV + i * STEPWV, 
                sensitivity: SPD2(MINWV + i * STEPWV, 0, shifts, use_factor=false)
            }))
        
        data = Array.from({length: NUMWV}, (v, i) => ({
            wavelength: MINWV + i * STEPWV, 
            sensitivity: {a:0, b:0, c:0}
        }));
        svgElement.selectAll("circle")
            .data(data)
            .attr("cy", d=>y(d.intensity));
        updateColor();
        setTimeout(()=>{
            updateColor();
        }, 100)
    }

    ////////// Create Static Objects //////////

    // Math Objects
    const x = d3.scaleLinear().domain([400, 700]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([-0.5, 3]).range([graphHeight, 0]);
    const lineWithShift = [
        d3.line()
            .x(d => x(d.wavelength+shifts[0]))
            .y(d => y(d.sensitivity.a)),
        d3.line()
            .x(d => x(d.wavelength+shifts[1]))
            .y(d => y(d.sensitivity.b)),
        d3.line()
            .x(d => x(d.wavelength+shifts[2]))
            .y(d => y(d.sensitivity.c))
    ]
    // const lineWithShift = [
    //     d3.line()
    //         .x(d => x(d.wavelength))
    //         .y(d => y(d.sensitivity.a)),
    //     d3.line()
    //         .x(d => x(d.wavelength))
    //         .y(d => y(d.sensitivity.b)),
    //     d3.line()
    //         .x(d => x(d.wavelength))
    //         .y(d => y(d.sensitivity.c))
    // ]

    // On-Site (D3) Static Objects
    const svgElement = d3.select(svgSensitivityCVD)
        .append("g")
        .attr("transform", `translate(${margin.left},${margin.top})`)

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
        .attr("x", titleX)
        .attr("y", titleY)
        .attr("text-anchor", "middle")
        .style("font-size", "22px")
        .text("Spectral Sensitivity (CVD, LMS only)");
    
    // Axis Labels
    svgElement.append("text")
        .attr("class", "x label")
        .attr("text-anchor", "middle")
        .attr("x", XLabelX)
        .attr("y", XLabelY)
        .text("Light Wavelength (nm)");
    
    svgElement.append("text")
        .attr("class", "y label")
        .attr("text-anchor", "middle")
        .attr("y", YLabelY)
        .attr("x", YLabelX)
        .text("Perceptual Sensitivity")
        .attr("transform", "rotate(-90)")


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
        maxData=Array.from({length: NUMWV}, (v, i) => ({
            wavelength: MINWV + i * STEPWV, 
            sensitivity: SPD2(MINWV + i * STEPWV, 0, shifts, use_factor=false)
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
                    .attr("d", lineWithShift[bar]))
            
            // Assign right path
            path.push(
                svgElement.append("path")
                    .datum(data)
                    .attr("class", "path")
                    .attr("stroke", COLORSPACEINFO[COLORSPACES[space]].symbolicColors[bar])
                    .attr("d", lineWithShift[bar]))

            // Assign checkpoints
            svgElement.selectAll(".cp"+bar)
                .data(data)
                .enter().append("circle")
                .attr("class", "cp cp"+bar)
                .attr("cx", d => x(d.wavelength))
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

    function updateColor() {
        // Old version
        // let tr = 0, tg = 0, tb = 0;
        // let factor = COLORSPACEINFO.RGB.factor;
        // let norm = COLORSPACEINFO.RGB.norm;
        // let standard = COLORSPACEINFO.RGB.standard;
        // data.forEach(d => {
        //     let {a, b, c} = SPD2(d.wavelength, 1);
        //     tr += parseFloat(a) * d.intensity * factor * standard[0]/norm[0];
        //     tg += parseFloat(b) * d.intensity * factor * standard[1]/norm[1];
        //     tb += parseFloat(c) * d.intensity * factor * standard[2]/norm[2];
        // });
        // tr = Math.round(tr);
        // tg = Math.round(tg);
        // tb = Math.round(tb);
        
        // colorSample.style.backgroundColor = `rgb(${tr}, ${tg}, ${tb})`;
    
        // Update LMS color 
        var colorLMS = JSON.parse(localStorage.getItem("LMSNorm"));
        colorLMS = [colorLMS.a,colorLMS.b,colorLMS.c]
        var colorLMSCVD = JSON.parse(localStorage.getItem("LMSCVDNorm"));
        colorLMSCVD = [colorLMSCVD.a,colorLMSCVD.b,colorLMSCVD.c]
    
        // Update RGB color
        var colorRGB = multiply(LMS2RGB, colorLMS);
        colorRGB = colorRGB.map(chan => Math.round(25500*chan)/100)
        colorSample.style.backgroundColor = `rgb(${colorRGB[0]}, ${colorRGB[1]}, ${colorRGB[2]})`;
        localStorage.setItem("RGBStandard", JSON.stringify(colorRGB));
        // For CVD
        var colorRGBCVD = multiply(LMS2RGB, colorLMSCVD);
        colorRGBCVD = colorRGBCVD.map(chan => Math.round(25500*chan)/100)
        colorSample2.style.backgroundColor = `rgb(${colorRGBCVD[0]}, ${colorRGBCVD[1]}, ${colorRGBCVD[2]})`;
        localStorage.setItem("RGBCVDStandard", JSON.stringify(colorRGBCVD));
    
        // Update XYZ color
        var colorXYZ = multiply(LMS2XYZ, colorLMS);
        colorXYZ = colorXYZ.map(chan => Math.round(100*chan)/100)
        localStorage.setItem("XYZStandard", JSON.stringify(colorXYZ));
    }


    // Update sensitivity based on SPD graph
    setInterval(function() {
        let SPDData = JSON.parse(localStorage.getItem("SPD"));
        if (SPDData == null){
            console.error("SPD Data could not be loaded")
        }
        var tempData;
        tempData = Array.from({length: NUMWV}, (v, i) => ({
            wavelength: MINWV + i * STEPWV, 
            sensitivity: {a:0, b:0, c:0}
        }));
        SPDData.forEach((value, idx)=>{
            // Modify Data
            tempData[idx].sensitivity = {
                a: maxData[idx].sensitivity.a * value.intensity,
                b: maxData[idx].sensitivity.b * value.intensity,
                c: maxData[idx].sensitivity.c * value.intensity,
            }

            data[idx].sensitivity = tempData[idx].sensitivity
            for (let bar = 0; bar < 3; bar++){
                let T = 'abc'[bar];
                // CP Nodes
                svgElement.selectAll(".cp"+bar)
                    .filter((_, i) => idx === i)
                    .attr("cy", y(tempData[idx].sensitivity[T]));
            }
        })

        // Calculate Sum and Save Data
        let factor = COLORSPACEINFO[COLORSPACES[0]].factor;
        let norm = COLORSPACEINFO[COLORSPACES[0]].norm;
        let standard = COLORSPACEINFO[COLORSPACES[0]].standard;
        let sumA = (total, add)=>total+add.sensitivity.a;
        let sumB = (total, add)=>total+add.sensitivity.b;
        let sumC = (total, add)=>total+add.sensitivity.c;
        colorStandard = { // from color space specific
            a: Math.round(ROUNDING*tempData.reduce(sumA, 0)*factor*standard[0]/norm[0])/ROUNDING,
            b: Math.round(ROUNDING*tempData.reduce(sumB, 0)*factor*standard[1]/norm[1])/ROUNDING,
            c: Math.round(ROUNDING*tempData.reduce(sumC, 0)*factor*standard[2]/norm[2])/ROUNDING
        }
        colorNormalized = { // from [0, 1]
            a: Math.round(NORMROUNDING*tempData.reduce(sumA, 0)*factor/norm[0])/NORMROUNDING,
            b: Math.round(NORMROUNDING*tempData.reduce(sumB, 0)*factor/norm[1])/NORMROUNDING,
            c: Math.round(NORMROUNDING*tempData.reduce(sumC, 0)*factor/norm[2])/NORMROUNDING
        }
        localStorage.setItem(COLORSPACES[0]+"CVDStandard", JSON.stringify(colorStandard));
        localStorage.setItem(COLORSPACES[0]+"CVDNorm", JSON.stringify(colorNormalized));
        
        //
        for (let bar = 0; bar < 3; bar++){
            let T = 'abc'[bar];
            // CP Path
            path[bar].attr("d", lineWithShift[bar]);
            // Sum Bar
            sumBar[bar]
                .attr("height", Math.abs(y(0)-y(colorNormalized[T])))
                .attr("y", Math.min(y(0), y(colorNormalized[T])))
        }
        
    }, DELAY)

});
