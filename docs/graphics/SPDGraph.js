document.addEventListener("DOMContentLoaded", function() {

    // Elements
    const colorSample = document.getElementById("colorSample");
    const resetButton = document.getElementById('resetButton');

    //////////////////// SPD ////////////////////

    ////////// SPD - Create GUI //////////

    resetButton.addEventListener('click', function() {
        this.innerText = 'Reset Done';
        resetSPD();
        setTimeout(()=>{this.innerText = "Reset";}, 1000);
    });

    ////////// SPD - Create Static Objects //////////

    // Math Objects
    const x = d3.scaleLinear().domain([400, 700]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([0, 1]).range([graphHeight, 0]);
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

    svgElement.append("text")
        .attr("x", width / 2 - 40)
        .attr("y", -margin.top / 2+30)
        .attr("text-anchor", "middle")
        .style("font-size", "18px")
        .text("Spectral Power Distribution (Φ)");

    ////////// SPD - Create Movable Graph Objects //////////
    // On-Site (D3) Dynamic Objects
    let data = Array.from({length: NUMWV}, (v, i) => ({wavelength: MINWV + i * STEPWV, intensity: 0}));

    const indicator = svgElement.append("circle")
        .attr("fill", "blue")
        .attr("r", 5)
        .attr("visibility", "hidden")

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
        indicator.attr("visibility", "visible");
    }
    function dragged(event, d) {
        const newX = x.invert(d3.pointer(event, this)[0]);
        const index = d3.bisectLeft(data.map(d => d.wavelength), newX);
    
        if (index > 0 && index < data.length) {
            const intensity = y.invert(event.y); // map mouse position to [0, 1]
    
            data[index].intensity = Math.max(MININTENSITY, Math.min(MAXINTENSITY, intensity)); // clamp between [0, 1]
            svgElement.selectAll("circle")
                .filter((_, idx) => idx === index)
                .attr("cy", y(data[index].intensity)); // any node at index should change
    
            path.attr("d", line);
            updateColor(data);

            indicator.attr("cx", x(newX));
            indicator.attr("cy", y(intensity));
        }
    }

    function dragended(event, d) {
        indicator.attr("visibility", "hidden");
    }

    function resetSPD() {
        data = Array.from({length: 61}, (v, i) => ({
            wavelength: 400 + i * 5,
            intensity: 0
        }));
        svgElement.selectAll("circle").attr("cy", y(0));
        path.datum(data).attr("d", line);
        updateColor(data);
    }

    function updateColor() {
        // Update ColorSample element
        let tr = 0, tg = 0, tb = 0;
        let norm = COLORSPACEINFO.RGB.norm;
        data.forEach(d => {
            let {a, b, c} = SPD2(d.wavelength, 1);
            tr += parseFloat(a) * d.intensity * 256/norm[0];
            tg += parseFloat(b) * d.intensity * 256/norm[1];
            tb += parseFloat(c) * d.intensity * 256/norm[2];
        });
        tr = Math.round(tr);
        tg = Math.round(tg);
        tb = Math.round(tb);
        const color = `rgb(${tr}, ${tg}, ${tb})`;
        colorSample.style.backgroundColor = color;
        console.log(JSON.stringify(color))

        // Update local storage
        localStorage.setItem("SPD", JSON.stringify(data));
    }

    // Init
    localStorage.setItem("RGB", JSON.stringify({r:0, g:0, b:0}));
    localStorage.setItem("SPD", JSON.stringify(data));
    updateColor(data);
});
