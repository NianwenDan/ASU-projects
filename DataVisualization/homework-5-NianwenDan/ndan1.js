// D3 Graph Global Setting
const margin = { top: 10, right: 15, bottom: 35, left: 40 };
const color = d3.scaleOrdinal(d3.schemeCategory10); // Define Color Scale

// select for Immigration Chart
let immigrationSvg = d3.select('#immigration_svg');

// select for Unemployment Chart
let unemploymentSvg = d3.select('#unemployment_svg');

// Dimensions for SVG containers
const width = +immigrationSvg.style('width').replace('px', '') - margin.left - margin.right;
const height = +unemploymentSvg.style('height').replace('px', '') - margin.top - margin.bottom;

immigrationSvg =  immigrationSvg.attr('width', width + margin.left + margin.right)
                .attr('height', height + margin.top + margin.bottom)
                .append('g')
                .attr('transform', `translate(${margin.left},${margin.top})`);

unemploymentSvg =  unemploymentSvg.attr('width', width + margin.left + margin.right)
                .attr('height', height + margin.top + margin.bottom)
                .append('g')
                .attr('transform', `translate(${margin.left},${margin.top})`);

// Function to draw a line chart
function drawLineChart(svg, data, attributes, xLabel, yLabel) {
    // Define scales
    const x = d3.scaleTime().range([0, width]);
    const y = d3.scaleLinear().range([height, 0]);

    // Set domains based on data
    x.domain(d3.extent(data, d => d.Year));
    y.domain([-10, d3.max(data, d => d3.max(attributes.map(attr => d[attr])))]);

    // Add X axis
    svg.append('g')
        .attr('transform', `translate(0,${height})`)
        .call(d3.axisBottom(x).tickFormat(d3.format('d')));

    // Add Y axis
    svg.append('g')
        .call(d3.axisLeft(y));

    // Add Lines for each attribute
    attributes.forEach((attr, i) => {
        const line = d3.line()
            .x(d => x(d.Year))
            .y(d => y(d[attr]));

        svg.append('path')
            .datum(data)
            .attr('fill', 'none')
            .attr('stroke', color(i))
            .attr('stroke-width', 2)
            .attr('d', line);

        // Add Legend
        svg.append('rect')
            .attr('x', width - 120)
            .attr('y', 20 + i * 20 - 10) // Adjust position of rectangles
            .attr('width', 10)
            .attr('height', 10)
            .attr('fill', color(i));

        svg.append('text')
            .attr('x', width - 100)
            .attr('y', 20 + i * 20) // Align text with rectangles
            .attr('fill', color(i))
            .style('font-size', '10px')
            .text(attr);
    });

    // Add labels
    svg.append('text')
        .attr('transform', `translate(${width / 2},${height + margin.bottom-5})`)
        .style('text-anchor', 'middle')
        .text(xLabel);

    svg.append('text')
        .attr('transform', 'rotate(-90)')
        .attr('y', 0 - margin.left)
        .attr('x', 0 - height / 2)
        .attr('dy', '1em')
        .style('text-anchor', 'middle')
        .text(yLabel);
}
d3.csv('data/data.csv').then(data => {
    data.forEach(d => {
        d.Year = +d.Year;
        d['LPR Rate (%)'] = +d['LPR Rate (%)'];
    });
    const filteredData = data.filter(d => d.Year >= 2010 && d.Year <= 2020);
    const attributes = ['LPR Rate (%)', 'Wages Change Rate (%)'];
    drawLineChart(immigrationSvg, filteredData, attributes, 'Year', 'Rate (%)');
});
d3.csv('data/data.csv').then(data => {
    data.forEach(d => {
        d.Year = +d.Year;
        Object.keys(d).forEach(key => {
            if (key !== 'Year') d[key] = +d[key];
        });
    });
    const filteredData = data.filter(d => d.Year >= 2010 && d.Year <= 2020);
    const attributes = ['LPR Rate (%)', 'Unemployment Rate (%)'];
    drawLineChart(unemploymentSvg, filteredData, attributes, 'Year', 'Rate (%)');
});