// data
let monthesName = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
// let yearsName = [2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]
let yearsName = []
let attrDropdown = document.querySelector('#attr-dropdown');
let plotDomainMin = document.querySelector('#plotDomainMin');
let plotDomainMax = document.querySelector('#plotDomainMax');
let updateBtn = document.querySelector('#updateBtn');
let radialScale = d3.scaleLinear().domain([0, 0]).range([0, 250]);

// d3
const width = 1000;
const height = 1000;
const svg = d3.select("#radioChart").attr("width", width).attr("height", height);
let raderCircle = svg.append('g').attr('class', 'raderCircle');
let ticklabels =  svg.append('g').attr('class', 'ticklabels');
let axisline = svg.append('g').attr('class', 'axisline');
let axislabel = svg.append('g').attr('transform', 'translate(-10,5)').attr('class', 'axislabel');
let dataPath = svg.append('g');
let dots = d3.select("svg").append("g").attr("class", `dots`);
let colorScale = d3.scaleOrdinal(d3.schemeCategory10);


updateBtn.addEventListener('click', () => {
    function calculateMonthlyAverage(data, attribute, years) {
        const monthlyData = {};
    
        data.forEach(entry => {
            const date = new Date(entry.datetime);
            const month = date.getMonth(); // zero-indexed (0 = Jan, 11 = Dec)
            const year = date.getFullYear();
            const value = parseFloat(entry[attribute]); // Dynamically fetch the attribute

            if (!years.includes(year)) return;
    
            if (!monthlyData[year]) {
                monthlyData[year] = Array(12).fill(null).map(() => ({ total: 0, count: 0 }));
            }
    
            monthlyData[year][month].total += value;
            monthlyData[year][month].count += 1;
        });
    
        // calculate the average for each month and convert to the required output format
        const avgEachMonthObj = {};
        for (const year in monthlyData) {
            avgEachMonthObj[year] = {};
    
            monthlyData[year].forEach((monthData, index) => {
                if (monthData.count > 0) {
                    avgEachMonthObj[year][monthesName[index]] = monthData.total / monthData.count;
                }
            });
        }

        const avgEachMonthD3 = []
        for (const [year, value] of Object.entries(avgEachMonthObj)) {
            avgEachMonthD3.push({
                'year': +year,
                'value' : value
            })
        }
    
        return avgEachMonthD3;
    }

    function groupDataByMonth(data, attribute, years) {
        const groupedData = [];
    
        data.forEach(entry => {
            const date = new Date(entry.datetime);
            const month = date.getMonth(); // zero-indexed (0 = Jan, 11 = Dec)
            const year = date.getFullYear();
            const value = parseFloat(entry[attribute]);
    
            // Only include specified years
            if (!years.includes(year)) return;
    
            // Find if the year and month combination already exists in groupedData
            let yearMonthEntry = groupedData.find(item => item.year === year && item.month === monthesName[month]);
    
            // If it doesn't exist, create a new entry
            if (!yearMonthEntry) {
                yearMonthEntry = {
                    year: year,
                    month: monthesName[month],
                    value: []
                };
                groupedData.push(yearMonthEntry);
            }
    
            // Add the value to the month's list
            yearMonthEntry.value.push(value);
        });
    
        return groupedData;
    }

    function setUpDefaultPlotDomain(data) {
        let maxValue = d3.max(data.flatMap(d => Object.values(d.value)));
        let minValue = d3.min(data.flatMap(d => Object.values(d.value)));
        maxValue = Math.ceil(maxValue + maxValue * 0.05);
        minValue = Math.floor(minValue - 10);
        return [minValue, maxValue]
    }

    function setUpDefaultPlotTicks(domain) {
        let tickCandidates = [0, 18, 26, 30, 60, 70, 80, 90]
        let ticks = [];
        for (let t of tickCandidates) {
            if (t < domain[1] && t > domain[0]) {
                ticks.push(t);
            }
        }
        ticks.push(domain[1]);
        // console.log(ticks);
        return ticks;
    }

    function showDefaultDomain(domain) {
        if (plotDomainMin.value == '') {
            plotDomainMin.value = domain[0];
            plotDomainMin.disabled = false;
        }
        if (plotDomainMax.value == '') {
            plotDomainMax.value = domain[1];
            plotDomainMax.disabled = false;
        }
        return [+plotDomainMin.value, +plotDomainMax.value]
    }

    function getSelectedYears() {
        const checkboxes = document.querySelectorAll('#year-checkBox .form-check-input');
        let selectedYears = [];
        checkboxes.forEach((checkbox) => {
            if (checkbox.checked) {
                selectedYears.push(parseInt(checkbox.value, 10));
            }
        });
        return selectedYears;
    }

    let dropDownValue = attrDropdown.value;
    d3.csv('./dc_weather.csv')
        .then(dataset => {
            // console.log(dataset);
            yearsName = getSelectedYears();
            const avgByMonthData = calculateMonthlyAverage(dataset, dropDownValue, yearsName);
            const allDataByMonth = groupDataByMonth(dataset, dropDownValue, yearsName);
            const domain = showDefaultDomain(setUpDefaultPlotDomain(avgByMonthData));
            const ticks = setUpDefaultPlotTicks(domain);
            console.log(allDataByMonth);
            drawRadarChart(avgByMonthData, allDataByMonth, yearsName, domain, ticks);
        })
        .catch(error => {
            console.log('Error loading the dataset:', error);
        })
})

attrDropdown.addEventListener('change', () => {
    let dropDownValue = attrDropdown.value;
    if (dropDownValue != '') {
        updateBtn.disabled = false;
    } else {
        updateBtn.disabled = true;
    }
    plotDomainMin.value = '';
    plotDomainMax.value = '';
    plotDomainMin.disabled = true;
    plotDomainMax.disabled = true;
})

function drawRadarChart(avgByMonthData, allDataByMonth, selectedYears, domain, ticks) {
    showLegend();
    radialScale.domain(domain).range([0, 250]);
    
    raderCircle.selectAll("circle")
        .data(ticks)
        .join(
            enter => enter.append("circle")
                .attr("cx", width / 2)
                .attr("cy", height / 2)
                .attr("fill", "none")
                .attr("stroke", "gray")
                .attr("opacity", 0)
                .attr("r", 0)
                .transition().duration(750)
                .attr("opacity", 1)
                .attr("r", d => radialScale(d)),
            update => update.transition().duration(750)
                .attr("r", d => radialScale(d)),
            exit => exit.remove()
        );
    
    
    ticklabels.selectAll("text")
        .data(ticks)
        .join(
            enter => enter.append("text")
                .attr("x", width / 2 + 5)
                .attr("y", d => height / 2 - radialScale(d))
                .text(d => d.toString())
                .attr("opacity", 0)
                .transition().duration(750)
                .attr("opacity", 1),
            update => update.transition().duration(750)
                .attr("y", d => height / 2 - radialScale(d))
                .text(d => d.toString()),
            exit => exit.remove()
        );
    
    
    function angleToCoordinate(angle, value){
        let x = Math.cos(angle) * radialScale(value);
        let y = Math.sin(angle) * radialScale(value);
        return {"x": width / 2 + x, "y": height / 2 - y};
    }
    
    
    let monthesData = monthesName.map((f, i) => {
        let angle = (Math.PI / 2) + (2 * Math.PI * i / monthesName.length);
        return {
            "name": f,
            "angle": angle,
            "line_coord": angleToCoordinate(angle, domain[1]),
            "label_coord": angleToCoordinate(angle, domain[1] + domain[1] * 0.1)
        };
    });
    
    // draw axis line
    axisline.selectAll("line")
        .data(monthesData)
        .join(
            enter => enter.append("line")
                .attr("x1", width / 2)
                .attr("y1", height / 2)
                .attr("x2", d => d.line_coord.x)
                .attr("y2", d => d.line_coord.y)
                .attr("stroke","black")
                .attr("opacity", 0)
                .transition().duration(1000)
                .attr("opacity", 1),
            update => update.transition().duration(750)
                .attr("x2", d => d.line_coord.x)
                .attr("y2", d => d.line_coord.y),
            exit => exit.remove()
        );
    
    // draw axis label
    axislabel.selectAll("text")
        .data(monthesData)
        .join(
            enter => enter.append("text")
                .attr("x", d => d.label_coord.x)
                .attr("y", d => d.label_coord.y)
                .text(d => d.name),
            update => update.transition().duration(750)
                .attr("x", d => d.label_coord.x)
                .attr("y", d => d.label_coord.y),
            exit => exit.remove()
        );
    const allYears = [2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]
    for (let y of allYears) {
        if (!selectedYears.includes(y)) {
            dots.selectAll(`.year-${y}`).attr("opacity", 1).transition().duration(750).attr("opacity", 0).remove();
        }
    }

    allDataByMonth.forEach(monthData => {
        // get the index of the month to calculate the angle
        const monthIndex = monthesName.indexOf(monthData.month);
        if (monthIndex === -1) return; // skip if month is not found
        // calculate the angle for this month
        const angle = (Math.PI / 2) + (2 * Math.PI * monthIndex / monthesName.length);
        // select the group for each year
        const yearGroup = dots.selectAll(`.year-${monthData.year}-${monthData.month}`)
                                    .data([monthData])
                                    .join(
                                        enter => enter.append('g')
                                                    .attr("class", `year-${monthData.year} year-${monthData.year}-${monthData.month}`)
                                    );

        yearGroup.selectAll("circle")
                    .data(monthData.value, (d, i) => i)
                    .join(
                        enter => enter.append("circle")
                            .attr("cx", d => {
                                const baseCoord = angleToCoordinate(angle, d);
                                const offset = (Math.random() - 0.9) * 10;
                                return baseCoord.x + offset;
                            })
                            .attr("cy", d => {
                                const baseCoord = angleToCoordinate(angle, d);
                                const offset = (Math.random() - 0.9) * 10;
                                return baseCoord.y + offset;
                            })
                            .attr("r", 2)
                            .attr("fill", colorScale(monthData.year))
                            .attr("opacity", 0)
                            .transition()
                            .duration(1000)
                            .attr("opacity", 1),
                        update => update.transition()
                            .duration(1000)
                            .attr("cx", d => {
                                const baseCoord = angleToCoordinate(angle, d);
                                const offset = (Math.random() - 0.9) * 10;
                                return baseCoord.x + offset;
                            })
                            .attr("cy", d => {
                                const baseCoord = angleToCoordinate(angle, d);
                                const offset = (Math.random() - 0.9) * 10;
                                return baseCoord.y + offset;
                            })
                            .attr("fill", colorScale(monthData.year))
                            .attr("opacity", 1),
                        exit => exit.transition()
                            .duration(750)
                            .attr("opacity", 0)
                            .remove()
                    );
    });
    
    
    let line = d3.line()
        .x(d => d.x)
        .y(d => d.y);
    
    function getPathCoordinates(data_point) {
        let coordinates = [];
        for (let i = 0; i < monthesName.length; i++){
            let month = monthesName[i];
            let angle = (Math.PI / 2) + (2 * Math.PI * i / monthesName.length);
            coordinates.push(angleToCoordinate(angle, data_point[month]));
        }
        coordinates.push(coordinates[0]); // append the first point again at the end to close the path
        return coordinates;
    }
    
    // draw the path element
    dataPath.selectAll("path")
        .data(avgByMonthData)
        .join(
            enter => enter.append("path")
                .datum(d => getPathCoordinates(d.value))
                .attr("opacity", 0)
                .transition().duration(1200)
                .attr("opacity", 0.7)
                .attr("d", line)
                .attr('class', 'radarChartPath')
                .attr("stroke", (_, i) => colorScale(selectedYears[i])),
            update => update.transition().duration(750)
                .attr("stroke", (_, i) => colorScale(selectedYears[i]))
                .attr("d", d => line(getPathCoordinates(d.value))),
            exit => exit.transition()
                    .duration(750)
                    .attr("opacity", 0)
                    .remove()
        );
}

function showLegend() {
    let colorKey = svg.select('.colorkey');
    if (!colorKey.empty()) {
        colorKey.remove();
    }
    const categories = yearsName;
    colorKey = svg.append('g')
        .attr('class', 'colorkey');
    let yLocCounter = 10;
    let maxTextWidth = 0;
    categories.forEach((c) => {
        let rect = colorKey.append('rect')
            .attr("width", 10)
            .attr("height", 10)
            .attr("x", 0)
            .attr("y", yLocCounter)
            .style("fill", colorScale(c));

        let text = colorKey.append('text')
            .attr("x", 15)
            .attr("y", yLocCounter + 5)
            .attr("dy", "0.35em")
            .style("font-size", "12px")
            .text(c)
            .style("visibility", "hidden");

        let textWidth = text.node().getBBox().width;
        if (textWidth > maxTextWidth) {
            maxTextWidth = textWidth;
        }
        yLocCounter += 20;
    });
    colorKey.selectAll('text').style("visibility", "visible");
}