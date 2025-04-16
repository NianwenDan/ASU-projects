console.log('main.js');
const textArea = document.querySelector('#wordbox');
let inputText = textArea.value;
const submitBtn = document.querySelector('#submit-text');;
const treemapDiv = d3.select('#treemap_div');
const sankeyDiv = d3.select('#sankey_div');

// D3 Graph Global Setting
const margin = { top: 10, right: 10, bottom: 10, left: 10 };
const color = d3.scaleOrdinal(['consonants', 'vowels', 'punctuation'], d3.schemeSet3); // Define Color Scale
const tooltip = d3.select("#tooltip"); // Tooltip

// Object used to store stats data for group of identified chars
let consonantsStats = {};
let vowelsStats = {};
let punctuationStats = {};

const consonants = new Set(['b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','z']);
const vowels = new Set(['a','e','i','o','u','y']);
const punctuation = new Set(['.',',','!','?',':',';']);
const allIdentified = new Set([...consonants, ...vowels, ...punctuation]);

submitBtn.addEventListener('click', (evt) => {
    // Reset Sankey Label and Graph
    document.querySelector('#sankey_svg').innerHTML = '';
    document.querySelector('#flow_label').innerText = `Character flow for ...`;
    // Update inputText when user click submit text
    inputText = textArea.value;
    // console.log(inputText);
    preProcessData();
    drawTreeMap();
})

function preProcessData() {
    const inputTextLength = inputText.length;

    function initStatsObj(charsSet, StatsObj) {
        for (let c of charsSet) {
            StatsObj[c] = {};
            StatsObj[c]['cnt'] = 0;
            StatsObj[c]['prev'] = {};
            StatsObj[c]['post'] = {};
        }
    }

    initStatsObj(consonants, consonantsStats);
    initStatsObj(vowels, vowelsStats);
    initStatsObj(punctuation, punctuationStats);

    function countChars(curChar, preChar, postChar, StatsObj) {
        // count current char
        StatsObj[curChar]['cnt'] += 1;
        // count char - 1
        if (allIdentified.has(preChar)) {
            if (preChar in StatsObj[curChar]['prev']) {
                StatsObj[curChar]['prev'][preChar] += 1;
            } else {
                StatsObj[curChar]['prev'][preChar] = 1;
            }
        }
        // count char + 1
        if (allIdentified.has(postChar)) {
            if (postChar in StatsObj[curChar]['post']) {
                StatsObj[curChar]['post'][postChar] += 1;
            } else {
                StatsObj[curChar]['post'][postChar] = 1;
            }
        }
    }

    for (let i = 0; i < inputTextLength; ++i) {
        let curChar = inputText[i];
        let preChar = null;
        let postChar = null;
        // Find current, previous and post char
        if (i === 0) {
            postChar = inputText[i + 1];
        } else if ((i + 1) >= inputTextLength) {
            preChar = inputText[i - 1];
        } else {
            preChar = inputText[i - 1];
            postChar = inputText[i + 1];
        }
        // consonants
        if (consonants.has(curChar)) {
            countChars(curChar, preChar, postChar, consonantsStats);
        }
        // vowels
        if (vowels.has(curChar)) {
            countChars(curChar, preChar, postChar, vowelsStats);
        }
        // punctuation
        if (punctuation.has(curChar)) {
            countChars(curChar, preChar, postChar, punctuationStats);
        }
    }
    // console.log(consonantsStats);
    // console.log(vowelsStats);
    // console.log(punctuationStats);
}

function drawTreeMap() {
    let data = { name: "AllChars", children: [] };

    // Function for creating hierarchy structure for each group of chars
    function creatSubTree(name, stats) {
        let subTree = { name : name, children: [] };
        for (const [k, v] of Object.entries(stats)) {
            if (v.cnt === 0) {
                continue;
            }
            let cld = { name: k, value: v.cnt};
            subTree.children.push(cld);
        }
        return subTree;
    }
    // Create and push the returned object to data
    data.children.push(creatSubTree('consonants', consonantsStats));
    data.children.push(creatSubTree('vowels', vowelsStats));
    data.children.push(creatSubTree('punctuation', punctuationStats));

    treemapDiv.select('#treemap_svg').remove(); // Remove the old svg preventing dupticate
    const treemapSvg = treemapDiv.append("svg").attr('id', 'treemap_svg');
    const g = treemapSvg.append('g').attr('transform', `translate(${margin.left}, ${margin.top})`);

    // Define Drawing Area
    const width = +treemapSvg.style('width').replace('px', '');
    const height = +treemapSvg.style('height').replace('px', '');
    const innerWidth = width - margin['left'] - margin['right'];
    const innerHeight = height - margin['top'] - margin['bottom'];

    const root = d3.hierarchy(data).sum(d => d.value);
    
    d3.treemap()
        .size([innerWidth, innerHeight])
        .paddingInner(3)
        (root);
    
    // console.log(root);
    // console.log(root.leaves());

    // Use this information to add rectangles
    g.selectAll("rect")
        .data(root.leaves())
        .join("rect")
            .attr('x', function (d) { return d.x0; })
            .attr('y', function (d) { return d.y0; })
            .attr('width', function (d) { return d.x1 - d.x0; })
            .attr('height', function (d) { return d.y1 - d.y0; })
            .attr('id', d => `treemap_char_${d.data.name.charCodeAt(0)}`)
            .style("fill", function(d){ return color(d.parent.data.name)} )
            .on("click", (event, d) => {
                // Show Sankey after chick the treemap block
                drawSankey(d.data.name, d.data.value);
            })
            .on("mouseover", function (event, d) {
                // Show tooltip on hover
                tooltip.transition().duration(200).style("opacity", 1);
                tooltip.html(`Character: '${d.data.name}' <br> Count: ${d.data.value}`).style("left", (event.pageX + 15) + "px").style("top", (event.pageY - 30) + "px");
                document.querySelectorAll(`.sankey_char_${d.data.name.charCodeAt(0)}`).forEach((e) => e.classList.add('blink'));
            })
            .on("mousemove", function (event, d) {
                // Update tooltip position
                tooltip.style("left", (event.pageX + 15) + "px").style("top", (event.pageY - 30) + "px");
            })
            .on("mouseout", function (event, d) {
                // Hide tooltip on mouseout
                tooltip.transition().duration(200).style("opacity", 0);
                document.querySelectorAll(`.sankey_char_${d.data.name.charCodeAt(0)}`).forEach((e) => e.classList.remove('blink'));
            });
}

function drawSankey(char, numberOfChars) {
    if (!allIdentified.has(char)) { 
        return; 
    }

    function findCharType(char) {
        if (consonants.has(char)) {
            return 'consonants';
        } else if (vowels.has(char)) {
            return 'vowels';
        } else if (punctuation.has(char)) {
            return 'punctuation';
        } else {
            return 'unknown';
        }
    }

    function createNodesAndLinks(stats) {
        let preObj = stats['prev'];
        let postObj = stats['post'];
        let counter = 1
        for (const [k, v] of Object.entries(preObj)) {
            let node = { node : counter, name : k, 'charType' : findCharType(k), 'location' : 'prev' };
            let link = { source : counter, target : 0, value : v };
            data['nodes'].push(node);
            data['links'].push(link);
            counter += 1;
        }
        for (const [k, v] of Object.entries(postObj)) {
            let node = { node : counter, name : k, 'charType' : findCharType(k), 'location' : 'post'};
            let link = { source : 0, target : counter, value : v };
            data['nodes'].push(node);
            data['links'].push(link);
            counter += 1;
        }
    }

    // Update Title
    document.querySelector('#flow_label').innerText = `Character flow for '${char}'`;

    let data = { "nodes" : [], "links" : [] };
    const charType = findCharType(char);
    // current char should always be the first node
    data['nodes'].push({ "node" : 0, "name" : `${char}`, 'charType' : charType, 'location' : 'center'});

    // build up the data based on char type
    if (charType == 'consonants') {
        createNodesAndLinks(consonantsStats[char]);
    } else if (charType == 'vowels') {
        createNodesAndLinks(vowelsStats[char]);
    } else if (charType == 'punctuation') {
        createNodesAndLinks(punctuationStats[char]);
    } else {
        return
    }

    // skip to draw sankey if only contains 1 char
    if (data.nodes.length <= 1) {
        return
    }

    sankeyDiv.select('#sankey_svg').remove(); // Remove the old svg preventing dupticate
    const sankeySvg = sankeyDiv.append("svg").attr('id', 'sankey_svg');
    const g = sankeySvg.append('g').attr('transform', `translate(${margin.left}, ${margin.top})`);

    // Define Drawing Area
    const width = +sankeySvg.style('width').replace('px', '');
    const height = +sankeySvg.style('height').replace('px', '');
    const innerWidth = width - margin['left'] - margin['right'];
    const innerHeight = height - margin['top'] - margin['bottom'];


    let sankey = d3.sankey().nodeWidth(30).size([innerWidth, innerHeight]);
    let path = sankey.links();

    graph = sankey(data);

    // add in the links
    let link = g.append("g").selectAll(".link")
                        .data(graph.links)
                        .enter().append("path")
                        .attr("class", "link")
                        .attr("d", d3.sankeyLinkHorizontal())
                        .attr("stroke-width", function(d) { return d.width - 3; });
    
    // add in the nodes
    let node = g.append("g").selectAll(".node")
                .data(graph.nodes)
                .enter().append("g")
                .attr("class", "node");

    // add the rectangles for the nodes
    node.append("rect")
            .attr("x", function(d) { return d.x0; })
            .attr("y", function(d) { return d.y0; })
            .attr("height", function(d) { return d.y1 - d.y0; })
            .attr("width", sankey.nodeWidth())
            .style("fill", function(d){ return color(d.charType)} )
            .attr('class', d => `sankey_char_${d.name.charCodeAt(0)}`)
            .attr("rx", 5)
            .on("mouseover", function (event, d) {
                // Show tooltip on hover
                tooltip.transition().duration(200).style("opacity", 1);
                if (d.location === 'center') {
                    tooltip.html(`Character '${char}' appears ${numberOfChars} times.`).style("left", (event.pageX + 15) + "px").style("top", (event.pageY - 30) + "px");
                } else if (d.location === 'prev') {
                    tooltip.html(`Character '${d.name}' flows into <br> '${char}' ${d.value} times.`).style("left", (event.pageX + 15) + "px").style("top", (event.pageY - 30) + "px");
                } else if (d.location === 'post') {
                    tooltip.html(`Character '${char}' flows into <br> '${d.name}' ${d.value} times.`).style("left", (event.pageX + 15) + "px").style("top", (event.pageY - 30) + "px");
                } else {
                    tooltip.html('Unidentified').style("left", (event.pageX + 15) + "px").style("top", (event.pageY - 30) + "px");
                }
                document.querySelector(`#treemap_char_${d.name.charCodeAt(0)}`).classList.add('blink');
            })
            .on("mousemove", function (event, d) {
                // Update tooltip position
                tooltip.style("left", (event.pageX + 15) + "px").style("top", (event.pageY - 30) + "px");
            })
            .on("mouseout", function (event, d) {
                // Hide tooltip on mouseout
                tooltip.transition().duration(200).style("opacity", 0);
                document.querySelector(`#treemap_char_${d.name.charCodeAt(0)}`).classList.remove('blink');
            });

    // add in the title for the nodes
    node.append("text")
            .attr("x", function(d) { return d.x0 - 6; })
            .attr("y", function(d) { return (d.y1 + d.y0) / 2; })
            .attr("dy", "0.35em")
            .attr("text-anchor", "end")
            .text(function(d) { return d.name; })
            .filter(function(d) { return d.x0 < width / 2; })
            .attr("x", function(d) { return d.x1 + 6; })
            .attr("text-anchor", "start");
}