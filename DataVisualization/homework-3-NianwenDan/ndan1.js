// control panel
const datasetDropdown = document.querySelector('#dataset-attr-select');
const xAttrDropdown = document.querySelector('#x-attr-select');
const yAttrDropdown = document.querySelector('#y-attr-select');
const colorDropdown = document.querySelector('#color-attr-select');
const boxplotDropdown = document.querySelector('#boxplot-attr-select');
const submitBtn = document.querySelector('#update-plot');

// dataset
let data = null;
let selectedData = null;

// svg d3 setting
const scatterPlotSvg = d3.select('#scatterPlot');
const boxPlotSvg = d3.select('#boxPlot');
const margin = { top: 10, right: 30, bottom: 50, left: 60 };
const width = +scatterPlotSvg.style('width').replace('px', '');
const height = +scatterPlotSvg.style('height').replace('px', '');
const innerWidth = width - margin['left'] - margin['right'];
const innerHeight = height - margin['top'] - margin['bottom'];
let gScatterPlot = scatterPlotSvg.append('g').attr('transform', `translate(${margin['left']},${margin['top']})`);
let gBoxPlotSvg = boxPlotSvg.append('g').attr('transform', `translate(${margin['left']},${margin['top']})`);
const color = d3.scaleOrdinal(d3.schemeSet2); // create color scale

// init scatter plot axises
const xScaleScatterPlot = d3.scaleLinear().domain([0, 0]).range([0, innerWidth]);
const yScaleScatterPlot = d3.scaleLinear().domain([0, 0]).range([innerHeight, 0]);
// add x and y scale to the svg
const yAxisScatterPlot = gScatterPlot.append('g').call(d3.axisLeft(yScaleScatterPlot)).style("opacity", 0);
const xAxisScatterPlot = gScatterPlot.append('g').attr('transform', `translate(0,${innerHeight})`).call(d3.axisBottom(xScaleScatterPlot)).style("opacity", 0);

// init box plot axises
const xScaleBoxPlot = d3.scaleBand().range([0, innerWidth]).padding(0.5);
const yScaleBoxPlot = d3.scaleLinear().range([innerHeight, 0]);
// add x and y scale to the svg
const xAxisBoxPlot = gBoxPlotSvg.append('g').attr('transform', `translate(0,${innerHeight})`);
const yAxisBoxPlot = gBoxPlotSvg.append('g');


datasetDropdown.addEventListener('change', (e, v) => {
    console.log(`Dataset ${datasetDropdown.value} Selected`);
    function setDisableDropdown(isDisable) {
        const attrs = [xAttrDropdown, yAttrDropdown, colorDropdown, boxplotDropdown]
        for (let att of attrs) {
            att.disabled = isDisable;
        }
    }
    function getAttributeTypes(dataset) {
        const attributeTypes = {};
        // sample the first few rows to determine attribute types
        const sample = dataset.slice(0, 10);

        dataset.columns.forEach(column => {
            // check if the column values are primarily numeric
            const isNumeric = sample.every(row => !isNaN(+row[column]));
            attributeTypes[column] = isNumeric ? 'quantitative' : 'categorical';
        });
        return attributeTypes;
    }
    function populateDropdowns(dataset) {
        const attributeTypes = getAttributeTypes(dataset);

        const quantitativeColumns = dataset.columns.filter(col => attributeTypes[col] === 'quantitative');
        const categoricalColumns = dataset.columns.filter(col => attributeTypes[col] === 'categorical');

        populateDropdown(xAttrDropdown, quantitativeColumns);
        populateDropdown(yAttrDropdown, quantitativeColumns);
        populateDropdown(colorDropdown, categoricalColumns);
        populateDropdown(boxplotDropdown, quantitativeColumns);
    }
    function populateDropdown(dropdown, options) {
        dropdown.innerHTML = ''; // Clear current options
        // add empty option
        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.selected = true;
        dropdown.appendChild(defaultOption);
        // add all attrbutes in the dataset to the dropdown
        options.forEach(option => {
            const opt = document.createElement('option');
            opt.value = option;
            opt.textContent = option;
            dropdown.appendChild(opt);
        });
    }
    function datasetPreProcess(dataset) {
        const attributeTypes = getAttributeTypes(dataset);
        // parse all quantitative attribute from string to float
        dataset.forEach(d => {
            Object.entries(d).forEach(entry => {
                const [attrName, value] = entry;
                if (attributeTypes[attrName] === 'quantitative') {
                    d[attrName] = parseFloat(value);
                }
            })
        })
        // console.log(attributeTypes);
    }

    selectedValue = datasetDropdown.value;
    if (selectedValue == '') {
        data = null;
        setDisableDropdown(true);
        setSubmitBtnStatus(true);
    } else {
        const filePath = `./data/${selectedValue}.csv`;
        d3.csv(filePath)
            .then(dataset => {
                setDisableDropdown(false);
                populateDropdowns(dataset);
                datasetPreProcess(dataset);
                data = dataset; // save pre-processed dataset to data
                // Swal.fire({
                //     icon: "success",
                //     title: `Successfully Loaded Dataset ${selectedValue}`
                // });
            })
            .catch(error => {
                console.log('Error loading the dataset:', error);
                data = null;
                setDisableDropdown(true);
                setSubmitBtnStatus(true);
                Swal.fire({
                    icon: "error",
                    title: `Fail to Load Dataset ${selectedValue}`,
                    text: error
                });
            })
    }
})

submitBtn.addEventListener('click', (e, v) => {
    const axisTransitionTime = 1000;
    function getCurrentDropdownValue() {
        const xAttr = xAttrDropdown.value;
        const yAttr = yAttrDropdown.value;
        const colorAttr = colorDropdown.value;
        const boxplotAttr = boxplotDropdown.value;

        return [xAttr, yAttr, colorAttr, boxplotAttr]
    }
    function updateScatterPlot(xAttr, yAttr, colorAttr) {
        // update x and y scale
        const xMax = d3.max(data, d => d[xAttr]);
        const xMin = d3.min(data, d => d[xAttr]);
        const yMax = d3.max(data, d => d[yAttr]);
        const yMin = d3.min(data, d => d[yAttr]);
        xScaleScatterPlot.domain([xMin - (xMax - xMin) * 0.03, xMax + (xMax - xMin) * 0.03]).nice();
        yScaleScatterPlot.domain([yMin - (yMax - yMin) * 0.03, yMax + (yMax - yMin) * 0.03]).nice();
        // update x and y scale to the svg
        xAxisScatterPlot.transition().duration(axisTransitionTime).call(d3.axisBottom(xScaleScatterPlot)).style("opacity", 1);
        yAxisScatterPlot.transition().duration(axisTransitionTime).call(d3.axisLeft(yScaleScatterPlot)).style("opacity", 1);

        scatterPlotSvg.selectAll(".scatterplot-label").transition().duration(300).style("opacity", 0).remove();
        // text label for the x axis
        scatterPlotSvg.append("text")
            .attr("class", "scatterplot-label")
            .attr("transform", `translate(${innerWidth / 2 + margin.left}, ${height - 15})`)
            .style("text-anchor", "middle")
            .style("opacity", 0)
            .text(xAttr)
            .transition()
            .duration(axisTransitionTime)
            .style("opacity", 1);

        // text label for the y axis
        scatterPlotSvg.append("text")
            .attr("class", "scatterplot-label")
            .attr("transform", "rotate(-90)")
            .attr("y", 5)
            .attr("x", 0 - (innerHeight / 2 + margin.top))
            .attr("dy", "1em")
            .style("text-anchor", "middle")
            .style("opacity", 0)
            .text(yAttr)
            .transition()
            .duration(axisTransitionTime)
            .style("opacity", 1);

        console.log(data);
        function updateLegend() {
            let colorKey = scatterPlotSvg.select('.colorkey');
            if (!colorKey.empty()) {
                colorKey.remove();
            }
            const categories = Array.from(new Set(data.map(d => d[colorAttr])));
            colorKey = scatterPlotSvg.append('g')
                .attr('class', 'colorkey')
                .attr("transform", `translate(${innerWidth - 20}, 10)`);
            let yLocCounter = 10;
            let maxTextWidth = 0;
            categories.forEach((c) => {
                let rect = colorKey.append('rect')
                    .attr("width", 10)
                    .attr("height", 10)
                    .attr("x", 0)
                    .attr("y", yLocCounter)
                    .style("fill", color(c));
    
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
            colorKey.attr("transform", `translate(${innerWidth - maxTextWidth}, 10)`);
            colorKey.selectAll('text').style("visibility", "visible");
        }
        
        updateLegend()

        // check if a <g> element to hold all dots already exists
        let dotsGroup = gScatterPlot.select(".dots-group");
        if (dotsGroup.empty()) {
            dotsGroup = gScatterPlot.append("g").attr("class", "dots-group"); // if it doesn't exist, create it
        }
        // add or update dots with transition
        const dots = dotsGroup.selectAll("circle").data(data, (_, i) => i); // use index as an identifier
        dots.join(
            enter => enter.append("circle")
                .attr("cx", d => xScaleScatterPlot(d[xAttr]))
                .attr("cy", d => yScaleScatterPlot(d[yAttr]))
                .attr("r", 0) // start with radius 0 for smooth appearance
                .style("fill", d => color(d[colorAttr]))
                .transition().duration(1000)
                .attr("r", 3) // transition radius to final size
                .attr("id", (_, i) => `scatter-plot-dot-${i}`),
            update => update.transition().duration(1000) // transition existing points
                .attr("cx", d => xScaleScatterPlot(d[xAttr]))
                .attr("cy", d => yScaleScatterPlot(d[yAttr]))
                .style("fill", d => color(d[colorAttr])),
            exit => exit.transition().duration(1000) // transition exit points if needed
                .attr("r", 0)
                .remove()
        );
    }

    function lasso(xAttr, yAttr, colorAttr, boxplotAttr) {
        let coords = [];
        const lineGenerator = d3.line();
        function lassoDrawPath() {
            d3.select("#lasso")
                .style("stroke", "black")
                .style("stroke-width", 2)
                .style("fill", "#00000030")
                .attr("d", lineGenerator(coords));
        }

        function lassoDragStart() {
            coords = [];
            selectedData = null;
            d3.selectAll("#scatterPlot .dots-group circle").attr("stroke", null); // remove all strock
            d3.select("#lasso").remove();
            d3.select("#scatterPlot").append("path").attr("id", "lasso");
        }

        function lassoDragMove(event) {
            let mouseX = event.sourceEvent.offsetX;
            let mouseY = event.sourceEvent.offsetY;
            coords.push([mouseX, mouseY]);
            lassoDrawPath();
        }

        function lassoDragEnd() {
            // user just click but does not select anything
            if (coords.length === 0) {
                selectedData = null;
                updateBoxPlot(colorAttr, boxplotAttr);
                return;
            };

            let selected = [];
            d3.selectAll("#scatterPlot .dots-group circle").each((d, i) => {
                let point = [
                    xScaleScatterPlot(d[xAttr]) + margin['left'],
                    yScaleScatterPlot(d[yAttr]) + margin['top'],
                ]; // reminider to add margin

                if (d3.polygonContains(coords, point)) {
                    d3.select(`#scatter-plot-dot-${i}`).attr("stroke", "black");
                    selected.push(d);
                }
            });
            selectedData = selected;
            // console.log(`select: ${selectedData}`);
            updateBoxPlot(colorAttr, boxplotAttr);
        }

        lassoDragStart(); // calling this function manually to remove previous lasso when user updated

        const drag = d3.drag()
            .on("start", lassoDragStart)
            .on("drag", lassoDragMove)
            .on("end", lassoDragEnd);
        return drag;
    }

    function updateBoxPlot(colorAttr, boxplotAttr) {
        if (colorAttr === '') return;

        if (selectedData === null || selectedData.length === 0) { selectedData = []; }

        function groupSelectedData() {
            const uniqueCategories = Array.from(new Set(selectedData.map(d => d[colorAttr])));
            let gpData = {}
            // init grouped data object
            for (c of uniqueCategories) {
                gpData[c] = [];
            }
            // grouping selected data
            for (d of selectedData) {
                const attr = d[colorAttr]; // this will get user selected category for each data point
                gpData[attr].push(d[boxplotAttr]);
            }
            // convert the object into an array of dataset objects for easier processing
            let gpDataConverted = Object.keys(gpData).map(k => ({
                name: k,
                values: gpData[k]
            }));
            return gpDataConverted;
        }

        const groupedData = groupSelectedData();
        console.log(groupedData);

        // calculate box plot statistics for each dataset.
        groupedData.forEach(dataset => {
            dataset.values.sort(d3.ascending);
            const q1 = d3.quantile(dataset.values, 0.25);
            const q2 = d3.quantile(dataset.values, 0.5);
            const q3 = d3.quantile(dataset.values, 0.75);
            const iqr = q3 - q1;
            const min = dataset.values[0];
            const max = dataset.values[dataset.values.length - 1];
            const r0 = Math.max(min, q1 - iqr * 1.5);
            const r1 = Math.min(max, q3 + iqr * 1.5);
            dataset.quartiles = [q1, q2, q3];
            dataset.range = [r0, r1];
            dataset.outliers = dataset.values.filter(v => v < r0 || v > r1);
        });
        console.log(groupedData);

        // update scales
        const yMax = d3.max(groupedData, d => d.range[1]);
        const yMin = d3.min(groupedData, d => d.range[0]);
        xScaleBoxPlot.domain(groupedData.map(d => d.name));
        yScaleBoxPlot.domain([yMin - (yMax - yMin) * 0.03, yMax + (yMax - yMin) * 0.03]).nice();

        // update axes with transitions
        xAxisBoxPlot.transition().duration(axisTransitionTime).call(d3.axisBottom(xScaleBoxPlot));
        yAxisBoxPlot.transition().duration(axisTransitionTime).call(d3.axisLeft(yScaleBoxPlot));

        boxPlotSvg.selectAll(".scatterplot-label").transition().duration(300).style("opacity", 0).remove();
        // text label for the x axis
        boxPlotSvg.append("text")
            .attr("class", "scatterplot-label")
            .attr("transform", `translate(${innerWidth / 2 + margin.left}, ${height - 15})`)
            .style("text-anchor", "middle")
            .style("opacity", 0)
            .text(colorAttr)
            .transition()
            .duration(axisTransitionTime)
            .style("opacity", 1);

        // text label for the y axis
        boxPlotSvg.append("text")
            .attr("class", "scatterplot-label")
            .attr("transform", "rotate(-90)")
            .attr("y", 5)
            .attr("x", 0 - (innerHeight / 2 + margin.top))
            .attr("dy", "1em")
            .style("text-anchor", "middle")
            .style("opacity", 0)
            .text(boxplotAttr)
            .transition()
            .duration(axisTransitionTime)
            .style("opacity", 1);


        const lineMargin = xScaleBoxPlot.bandwidth() * 0.2;

        const g = gBoxPlotSvg.selectAll(".box-group")
            .data(groupedData, d => d.name)
            .join(
                enter => {
                    const boxGroup = enter.append("g")
                        .attr("class", "box-group")
                        .attr("transform", d => `translate(${xScaleBoxPlot(d.name)},0)`)
                        .style("opacity", 0);

                    boxGroup
                        .transition()
                        .duration(500)
                        .style("opacity", 1);

                    // range line
                    boxGroup.append("line")
                        .attr("class", "range-line")
                        .attr("stroke", "currentColor")
                        .attr("x1", xScaleBoxPlot.bandwidth() / 2)
                        .attr("x2", xScaleBoxPlot.bandwidth() / 2)
                        .attr("y1", d => yScaleBoxPlot(d.range[0]))
                        .attr("y2", d => yScaleBoxPlot(d.range[1]));

                    // quartile rectangle
                    boxGroup.append("rect")
                        .attr("class", "quartile-rect")
                        .style("fill", d => color(d['name']))
                        .attr("x", 0)
                        .attr("width", xScaleBoxPlot.bandwidth())
                        .attr("y", d => yScaleBoxPlot(d.quartiles[2]))
                        .attr("height", d => yScaleBoxPlot(d.quartiles[0]) - yScaleBoxPlot(d.quartiles[2]));

                    // median line
                    boxGroup.append("line")
                        .attr("class", "median-line")
                        .attr("stroke", "currentColor")
                        .attr("stroke-width", 2)
                        .attr("x1", 0)
                        .attr("x2", xScaleBoxPlot.bandwidth())
                        .attr("y1", d => yScaleBoxPlot(d.quartiles[1]))
                        .attr("y2", d => yScaleBoxPlot(d.quartiles[1]));

                    // min line
                    boxGroup.append("line")
                        .attr("class", "min-line")
                        .attr("stroke", "currentColor")
                        .attr("stroke-width", 1)
                        .attr("x1", lineMargin)
                        .attr("x2", xScaleBoxPlot.bandwidth() - lineMargin)
                        .attr("y1", d => yScaleBoxPlot(d.range[0]))
                        .attr("y2", d => yScaleBoxPlot(d.range[0]));

                    // max line
                    boxGroup.append("line")
                        .attr("class", "max-line")
                        .attr("stroke", "currentColor")
                        .attr("stroke-width", 1)
                        .attr("x1", lineMargin)
                        .attr("x2", xScaleBoxPlot.bandwidth() - lineMargin)
                        .attr("y1", d => yScaleBoxPlot(d.range[1]))
                        .attr("y2", d => yScaleBoxPlot(d.range[1]));

                    // draw circles for each outlier
                    boxGroup.selectAll(".outlier-circle")
                        .data(d => d.outliers)
                        .join(
                            enter => enter.append("circle")
                                .attr("class", "outlier-circle")
                                .style("fill", d => color(d.name))
                                .attr("fill-opacity", 0.7)
                                .attr("r", 2)
                                .attr("cx", xScaleBoxPlot.bandwidth() / 2)
                                .attr("cy", d => yScaleBoxPlot(d)),
                            update => update
                                .style("fill", d => color(d['name']))
                                .attr("cx", xScaleBoxPlot.bandwidth() / 2)
                                .attr("cy", d => yScaleBoxPlot(d))
                        );
                },
                update => {
                    // update transformations and positions
                    const boxGroupUpdate = update.transition().duration(750)
                        .attr("transform", d => `translate(${xScaleBoxPlot(d.name)},0)`);

                    // range line update
                    boxGroupUpdate.select(".range-line")
                        .attr("x1", xScaleBoxPlot.bandwidth() / 2)
                        .attr("x2", xScaleBoxPlot.bandwidth() / 2)
                        .attr("y1", d => yScaleBoxPlot(d.range[0]))
                        .attr("y2", d => yScaleBoxPlot(d.range[1]));

                    // quartile rectangle update
                    boxGroupUpdate.select(".quartile-rect")
                        .attr("width", xScaleBoxPlot.bandwidth())
                        .attr("y", d => yScaleBoxPlot(d.quartiles[2]))
                        .attr("height", d => yScaleBoxPlot(d.quartiles[0]) - yScaleBoxPlot(d.quartiles[2]))
                        .style("fill", d => color(d['name']))

                    // median line update
                    boxGroupUpdate.select(".median-line")
                        .attr("x2", xScaleBoxPlot.bandwidth())
                        .attr("y1", d => yScaleBoxPlot(d.quartiles[1]))
                        .attr("y2", d => yScaleBoxPlot(d.quartiles[1]));

                    // min line update
                    boxGroupUpdate.select(".min-line")
                        .attr("x1", lineMargin)
                        .attr("x2", xScaleBoxPlot.bandwidth() - lineMargin)
                        .attr("y1", d => yScaleBoxPlot(d.range[0]))
                        .attr("y2", d => yScaleBoxPlot(d.range[0]));

                    // max line update
                    boxGroupUpdate.select(".max-line")
                        .attr("x1", lineMargin)
                        .attr("x2", xScaleBoxPlot.bandwidth() - lineMargin)
                        .attr("y1", d => yScaleBoxPlot(d.range[1]))
                        .attr("y2", d => yScaleBoxPlot(d.range[1]));

                    // outliers
                    update.selectAll(".outlier-circle")
                        .data(d => d.outliers)
                        .join(
                            enter => enter.append("circle")
                                .attr("class", "outlier-circle")
                                .style("fill", d => color(d.name))
                                .attr("fill-opacity", 0.7)
                                .attr("r", 2)
                                .attr("cx", xScaleBoxPlot.bandwidth() / 2)
                                .attr("cy", d => yScaleBoxPlot(d)),
                            update => update
                                .style("fill", d => color(d['name']))
                                .attr("cx", xScaleBoxPlot.bandwidth() / 2)
                                .attr("cy", d => yScaleBoxPlot(d))
                        );
                },
                exit => exit.transition()
                    .duration(375)
                    .style("opacity", 0) // fade out the entire group
                    .select(".quartile-rect")
                    .attr("height", 0)
                    .end()
                    .then(() => exit.remove()) // remove the group after transition completes
            );

    }

    // get current user selection
    const [xAttr, yAttr, colorAttr, boxplotAttr] = getCurrentDropdownValue();
    updateScatterPlot(xAttr, yAttr, colorAttr);
    d3.select("#scatterPlot").call(lasso(xAttr, yAttr, colorAttr, boxplotAttr));
})

function setSubmitBtnStatus(override) {
    if (xAttrDropdown.value !== '' && yAttrDropdown.value !== '' && colorDropdown.value != '' && boxplotDropdown.value != '') {
        submitBtn.disabled = false;
    } else {
        submitBtn.disabled = true;
    }
    if (override) {
        submitBtn.disabled = override;
    }
}

xAttrDropdown.addEventListener('change', () => { setSubmitBtnStatus(); })
yAttrDropdown.addEventListener('change', () => { setSubmitBtnStatus(); })
colorDropdown.addEventListener('change', () => { setSubmitBtnStatus(); })
boxplotDropdown.addEventListener('change', () => { setSubmitBtnStatus(); })