// Color settings
const MAXINTENSITY = 1.5;
const MININTENSITY = -0.5;
const MINWV = 400;
const STEPWV = 5;
const NUMWV = 61;
const COLORSPACEINFO = {
    // factor: for both display and numeric
    // norm: max value of bar's sum to normalize information SUM/norm -> [0, 1]
    // standard: supposed max value get to color standard SUM * standard/norm -> [0, 255] (RGB)
    LMS: {
        factor: 1, 
        standard: [23.18119,18.96224,11.65468], 
        norm: [23.18119,18.96224,11.65468], 
        rectLoc: [565, 525, 430], 
        symbolicColors: ['red', 'green', 'blue']
    }, 
    RGB: {
        factor: 1.2, 
        standard: [255,255,255], 
        norm: [64.44389, 27.98101, 15.7176], // 70.99387, 17.06739, 6.06154
        rectLoc: [585, 525, 430], 
        symbolicColors: ['red', 'green', 'blue']
    },
    XYZ: {
        factor: 1, 
        standard: [23.67205,23.69381,23.66061], 
        norm: [23.67205,23.69381,23.66061], 
        rectLoc: [580, 540, 430], 
        symbolicColors: ['red', 'green', 'blue']
    }
}
const COLORSPACES = Object.keys(COLORSPACEINFO);
const ROUNDING = 1;
const NORMROUNDING = 100;
const DELAY = 50;

// Size settings
var svgSPD;
var svgChromaticity;
var svgSensitivity;
var width, height, margin;
var graphWidth, graphHeight;

document.addEventListener("DOMContentLoaded", function() {
    svgSPD = document.getElementById("spdGraph");
    svgSensitivity = document.getElementById("sensitivityGraph");
    svgChromaticity = document.getElementById("chromaticityGraph");
    console.log(JSON.stringify(svgChromaticity))
    width = svgSPD.clientWidth;
    height = svgSPD.clientHeight;
    margin = {top: 20, right: 30, bottom: 30, left: 40};
    graphWidth = width - margin.left - margin.right;
    graphHeight = height - margin.top - margin.bottom;
})