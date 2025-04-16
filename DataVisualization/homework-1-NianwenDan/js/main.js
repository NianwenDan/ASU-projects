// Hint: This is a great place to declare your global variables
const countrySelecter = document.querySelector('#country-selecter');
let currentCountry = null;
let femaleData = null
let maleData = null

// Select svg
let svg = d3.select('#myDataVis').append('svg');
// formating variables
let margin = { top: 10, right: 30, buttom: 30, left: 60 };
const width = +svg.style('width').replace('px', '');
const height = +svg.style('height').replace('px', '');
const innerWidth = width - margin['left'] - margin['right'];
const innerHeight = height - margin['top'] - margin['buttom'];
const legendWidth = 220;
const legendHeight = 70;
// Add a g element with top/left margin offsets
let g = svg.append('g')
                .attr('transform', `translate(${margin['left']},${margin['top']})`);
let legends = svg.append('g')
                .attr('transform', `translate(${width - margin['right'] - legendWidth},${margin['top'] + 20})`);
// Create legends
legends.append('rect')
    .attr('width', legendWidth)
    .attr('height', legendHeight)
    .attr('x', -10)
    .attr('y', -10)
    .style('fill', 'white')
    .style('fill-opacity', '0.8');
legends.append('rect')
    .attr('width', 10)
    .attr('height', 10)
    .style('fill', '#69b3a2');
legends.append('rect')
    .attr('width', 10)
    .attr('height', 10)
    .attr('y', 30)
    .style('fill', 'red');
legends.append('text')
    .attr('x', 20)
    .attr('y', 10)
    .text('Female Employment Rate');
legends.append('text')
    .attr('x', 20)
    .attr('y', 40)
    .text('Male Employment Rate');

// Add X axis label:
svg.append("text")
    .attr("x", width / 2)
    .attr("y", height - 5)
    .text("Year");

// Y axis label:
svg.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 20)
    .attr("x", -(height / 2) - 50)
    .text("Employment Rate")


// This function is called once the HTML page is fully loaded by the browser
document.addEventListener('DOMContentLoaded', function () {
   // Hint: create or set your svg element inside this function
    
   // This will load your CSV files and store them into two arrays.
   Promise.all([d3.csv('data/females_data.csv'),d3.csv('data/males_data.csv')])
        .then(function (values) {
            console.log('Loaded the females_data.csv and males_data.csv');
            female_data = values[0];
            male_data = values[1];

            // Hint: This is a good spot for data wrangling
            function dataWrangling(arr) {
                arr.forEach(d => {
                    for (let key in d) {
                        if (key == 'Year') {
                            d[key] = d3.timeParse('%Y')(d[key])
                        } else {
                            d[key] = +d[key];
                        }
                    }
                })
            }
            dataWrangling(female_data);
            dataWrangling(male_data);
            femaleData = female_data
            maleData = male_data

            // Add options to selector
            for (c of femaleData['columns'].slice(1)) {
                let newOption = document.createElement('option');
                newOption.value = c;
                newOption.text = c;
                countrySelecter.appendChild(newOption);
            }
            currentCountry = countrySelecter.value;
            drawLolliPopChart(currentCountry);
        });
});

countrySelecter.addEventListener('change', function(evt) {
    currentCountry = countrySelecter.value; // Update current
    drawLolliPopChart(currentCountry); // Re-draw the plot
})


// Use this function to draw the lollipop chart.
function drawLolliPopChart(country) {
    console.log('trace:drawLolliPopChart()');

    // create x scale
    let xMin = d3.min(femaleData, function(d) { return d['Year']});
    let xMax = d3.max(femaleData, function(d) { return d['Year']});
    // TODO: Other ways to implement it
    let xMinWithOffset = new Date();
    let xMaxWithOffset = new Date();
    xMinWithOffset.setFullYear(xMin.getFullYear() - 2);
    xMaxWithOffset.setFullYear(xMax.getFullYear() + 1);
    let xScale = d3.scaleTime()
                    .domain([xMinWithOffset, xMaxWithOffset])
                    .range([0, innerWidth]);
    // create y scale
    let yMaleMax = d3.max(maleData, function(d) { return d[country]});
    let yFemaleMax = d3.max(femaleData, function(d) { return d[country]});
    let yScale = d3.scaleLinear()
                    .domain([0, Math.max(yMaleMax, yFemaleMax)])
                    .range([innerHeight, 0]);
    // add y-axis and x-axis to the plot
    g.append('g')
        .call(d3.axisLeft(yScale));
    g.transition().duration(1000).call(d3.axisLeft(yScale));

    g.append('g')
            .attr('transform', `translate(0,${innerHeight})`)
            .call(d3.axisBottom(xScale));

    // Create lines and circles of female data
    let lines_male = g.selectAll('.line-male')
        .data(maleData)
        lines_male.enter()
        .append('line')
        .attr('class', 'line-male')
        .merge(lines_male)
        .transition()
        .duration(1000)
            .attr('x1', function(d) { return xScale(d['Year']); }) // X position for both ends of the line
            .attr('x2', function(d) { return xScale(d['Year']); })
            .attr('y1', function(d) { return yScale(d[country]); }) // Top of the lollipop stick, based on the data value
            .attr('y2', yScale(0)) // Baseline at Y = 0
            .attr('transform', `translate(5, 0)`);
    let circles_male = g.selectAll('.circle-male')
        .data(maleData)
        circles_male.enter()
        .append('circle')
        .attr('class', 'circle-male')
        .merge(circles_male)
        .transition()
        .duration(1000)
            .attr('cx', function(d) { return xScale(d['Year']); })
            .attr('cy', function(d) { return yScale(d[country]); })
            .attr('r', 4)
            .attr('transform', `translate(5, 0)`);

    let lines_female = g.selectAll('.line-female')
        .data(femaleData)
        lines_female.enter()
        .append('line')
        .attr('class', 'line-female')
        .merge(lines_female)
        .transition()
        .duration(1000)
            .attr('x1', function(d) { return xScale(d['Year']); }) // X position for both ends of the line
            .attr('x2', function(d) { return xScale(d['Year']); })
            .attr('y1', function(d) { return yScale(d[country]); }) // Top of the lollipop stick, based on the data value
            .attr('y2', yScale(0)) // Baseline at Y = 0
            .attr('transform', `translate(-5, 0)`);
    let circles_female = g.selectAll('.circle-female')
        .data(femaleData)
        circles_female.enter()
        .append('circle')
        .attr('class', 'circle-female')
        .merge(circles_female)
        .transition()
        .duration(1000)
            .attr('cx', function(d) { return xScale(d['Year']); })
            .attr('cy', function(d) { return yScale(d[country]); })
            .attr('r', 4)
            .attr('transform', `translate(-5, 0)`);
}

