// Color settings
const MAXINTENSITY = 1.0;
const MININTENSITY = 0.0;
const MINWV = 400;
const STEPWV = 5;
const NUMWV = 61;
const COLORSPACEINFO = {
    LMS: {factor: 1, norm: [23, 19, 12], rectLoc: [565, 525, 430], symbolicColors: ['red', 'green', 'blue']}, 
    RGB: {factor: 1, norm: [45,19,11], rectLoc: [565, 525, 430], symbolicColors: ['red', 'green', 'blue']},
    XYZ: {factor: 1, norm: [24,24,24], rectLoc: [565, 525, 430], symbolicColors: ['red', 'green', 'blue']}
}
const COLORSPACES = Object.keys(COLORSPACEINFO);
const ROUNDING = 1000;
const DELAY = 50;

// Size settings
var svgSPD;
var svgSensitivity;
var width, height, margin;
var graphWidth, graphHeight;

document.addEventListener("DOMContentLoaded", function() {
    svgSPD = document.getElementById("spdGraph");
    svgSensitivity = document.getElementById("sensitivityGraph");
    width = svgSPD.clientWidth;
    height = svgSPD.clientHeight;
    margin = {top: 20, right: 30, bottom: 30, left: 40};
    graphWidth = width - margin.left - margin.right;
    graphHeight = height - margin.top - margin.bottom;
})