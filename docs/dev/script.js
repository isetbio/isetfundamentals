document.addEventListener("DOMContentLoaded", function() {
    // Elements
    const svg = document.getElementById("spdGraph");
    const colorSample = document.getElementById("colorSample");
    const resetButton = document.getElementById('resetButton');

    // Size settings
    const width = svg.clientWidth;
    const height = svg.clientHeight;
    const margin = {top: 20, right: 30, bottom: 30, left: 40};
    const graphWidth = width - margin.left - margin.right;
    const graphHeight = height - margin.top - margin.bottom;

    // Color settings
    const MAXINTENSITY = 1.0;
    const MININTENSITY = 0.0;

    //////////////////// SPD ////////////////////

    ////////// SPD - GUI //////////

    resetButton.addEventListener('click', function() {
        this.innerText = 'Reset Done';
        resetSPD();
        setTimeout(()=>{this.innerText = "Reset";}, 1000);
    });

    ////////// SPD - Graph //////////

    // Math Objects
    const x = d3.scaleLinear().domain([400, 700]).range([0, graphWidth]);
    const y = d3.scaleLinear().domain([0, 1]).range([graphHeight, 0]);
    const line = d3.line()
        .x(d => x(d.wavelength))
        .y(d => y(d.intensity))

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

    let data = Array.from({length: 61}, (v, i) => ({
        wavelength: 400 + i * 5,
        intensity: 0
    }));

    // On-Site (D3) Dynamic Objects
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
        .attr("fill", "red")
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
            updateColorSample(data);

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
        updateColorSample(data);
    }

    function updateColorSample() {
        const color = calculateColorFromSPD(data);
        colorSample.style.backgroundColor = color;
    }

    function calculateColorFromSPD() {
        // Simple placeholder function for calculating color from SPD
        // In practice, this would involve more sophisticated color science
        let r = 0, g = 0, b = 0;
        data.forEach(d => {
            if (d.wavelength >= 400 && d.wavelength < 500) {
                b += d.intensity * (d.wavelength - 400) / 100;
            } else if (d.wavelength >= 500 && d.wavelength < 600) {
                g += d.intensity * (d.wavelength - 500) / 100;
            } else if (d.wavelength >= 600 && d.wavelength <= 700) {
                r += d.intensity * (d.wavelength - 600) / 100;
            }
        });
        r = Math.min(Math.max(r, 0), 1);
        g = Math.min(Math.max(g, 0), 1);
        b = Math.min(Math.max(b, 0), 1);
        return `rgb(${Math.round(r * 255)}, ${Math.round(g * 255)}, ${Math.round(b * 255)})`;
    }

    updateColorSample(data);
});
