document.addEventListener("DOMContentLoaded", function() {

    // Elements
    const colorSample = document.getElementById("colorSample");
    const clampSwitch = document.getElementById('ClampSwitch');
    const blackButton = document.getElementById('blackButton');
    const whiteButton = document.getElementById('whiteButton');
    const redButton = document.getElementById('redButton');

    // Display Settings
    var minIntensityAllowed = 0.0;
    var maxIntensityAllowed = 1.0;

    //////////////////// SPD ////////////////////

    ////////// SPD - Create GUI //////////

    clampSwitch.addEventListener('change', (event) => {
        if (event.target.checked) {
            minIntensityAllowed = 0.0;
            maxIntensityAllowed = 1.0;
        } else {
            minIntensityAllowed = MININTENSITY;
            maxIntensityAllowed = MAXINTENSITY;
        }
    });

    blackButton.addEventListener('click', function() {
        resetSPD(Array.from({length: NUMWV}, (v,i)=>0));
    });
    whiteButton.addEventListener('click', function() {
        resetSPD(Array.from({length: NUMWV}, (v,i)=>1));
    });
    redButton.addEventListener('click', function() {
        resetSPD(Array.from({length: NUMWV}, 
            (v,i)=>(i<16)?0.0:((i<32)?-0.5:1.0045)
        ));
    });

    ////////// SPD - Create Static Objects //////////

    // Math Objects
    const x = d3.scaleLinear().domain([400, 700]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([MININTENSITY, MAXINTENSITY]).range([graphHeight, 0]);
    const line = d3.line()
        .x(d => x(d.wavelength))
        .y(d => y(d.intensity))

    // On-Site (D3) Static Objects
    const svgElement = d3.select(svgSPD)
        .append("g")
        .attr("transform", `translate(${margin.left},${margin.top})`)

    svgElement.append("g")
        .attr("class", "x axis")
        .attr("transform", `translate(0,${graphHeight})`)
        .call(d3.axisBottom(x));

    svgElement.append("g")
        .attr("class", "y axis")
        .call(d3.axisLeft(y));
    
    svgElement.append("rect")
        .attr("class", "badRangeUp")
        .attr("x", x(400))
        .attr("y", y(MAXINTENSITY))
        .attr("width", x(700)-x(400))
        .attr("height", y(1)-y(MAXINTENSITY))
        .attr("fill", "black")
        .attr("fill-opacity", 0.4)
    
    svgElement.append("rect")
        .attr("class", "badRangeDown")
        .attr("x", x(400))
        .attr("y", y(0))
        .attr("width", x(700)-x(400))
        .attr("height", y(MININTENSITY)-y(0))
        .attr("fill", "black")
        .attr("fill-opacity", 0.4)

    svgElement.append("text")
        .attr("x", width / 2 - 40)
        .attr("y", -margin.top / 2+30)
        .attr("text-anchor", "middle")
        .style("font-size", "18px")
        .text("Spectral Power Distribution (Φ)");

    ////////// SPD - Create Movable Graph Objects //////////
    // On-Site (D3) Dynamic Objects
    let data = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, intensity: 0}));

    const path = svgElement.append("path")
        .datum(data)
        .attr("class", "line")
        .attr("d", line)
        .attr("fill-opacity", 0)
        .attr("stroke", "red")
        .attr("stroke-width", 2);

    svgElement.selectAll("circle")
        .data(data)
        .enter().append("circle")
        .attr("r", 5)
        .attr("cx", d => x(d.wavelength))
        .attr("cy", d => y(d.intensity))
        .attr("fill", d => SPD2(d.wavelength, 1, rgb_css=true)) 
        //  data-toggle="tooltip" data-placement="left" title="Display all sensitivity points"
        .attr("data-toggle", "tooltip")
        .attr("data-placement", "left")
        .attr("data-bs-html", "true")
        .attr("title", d => `${d.wavelength}nm`)
        .call(d3.drag()
            .on("start", dragstarted)
            .on("drag", dragged)
            .on("end", dragended)
        )
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


    ////////// SPD - Event Handlers //////////
    
    function dragstarted(event, d) {
    }
    function dragged(event, d) {
        const newX = x.invert(d3.pointer(event, this)[0]);
        const index = d3.bisectLeft(data.map(d => d.wavelength), newX);
    
        if (index >= 0 && index < data.length) {
            const intensity = y.invert(event.y); // map mouse position to [0, 1]
    
            data[index].intensity = Math.max(minIntensityAllowed, Math.min(maxIntensityAllowed, intensity)); // clamp between [0, 1]
            svgElement.selectAll("circle")
                .filter((_, idx) => idx === index)
                .attr("cy", y(data[index].intensity)) // any node at index should change
    
            path.attr("d", line);
            updateColor(data);

        }
    }

    function dragended(event, d) {
    }

    function resetSPD(arr) {
        data = Array.from({length: NUMWV}, (v, i) => ({
            wavelength: MINWV + i * STEPWV,
            intensity: arr[i]
        }));
        console.log(JSON.stringify(data))
        svgElement.selectAll("circle")
            .data(data)
            .attr("cy", d=>y(d.intensity));
        path.datum(data).attr("d", line);
        updateColor(data);
    }

    function updateColor() {
        // Update ColorSample element
        let tr = 0, tg = 0, tb = 0;
        let factor = COLORSPACEINFO.RGB.factor;
        let norm = COLORSPACEINFO.RGB.norm;
        let standard = COLORSPACEINFO.RGB.standard;
        data.forEach(d => {
            let {a, b, c} = SPD2(d.wavelength, 1);
            tr += parseFloat(a) * d.intensity * factor * standard[0]/norm[0];
            tg += parseFloat(b) * d.intensity * factor * standard[1]/norm[1];
            tb += parseFloat(c) * d.intensity * factor * standard[2]/norm[2];
        });
        tr = Math.round(tr);
        tg = Math.round(tg);
        tb = Math.round(tb);
        const color = `rgb(${tr}, ${tg}, ${tb})`;
        colorSample.style.backgroundColor = color;

        // Update local storage
        localStorage.setItem("SPD", JSON.stringify(data));
    }

    // Init
    localStorage.setItem("RGB", JSON.stringify({r:0, g:0, b:0}));
    localStorage.setItem("SPD", JSON.stringify(data));
    updateColor(data);
});
