trainLine = document.getElementById("line").value
margin = 
	top: 20
	right: 20
	bottom: 30
	left: 50
width = 960 - margin.left - margin.right
height = 500 - margin.top - margin.bottom

x = d3.scale.linear().range([0, width])

y = d3.scale.linear().range([height,0])

xAxis = d3.svg.axis().scale(x).orient("bottom")

yAxis = d3.svg.axis().scale(y).orient("left")


makeGraph=()->
	svg = d3.select("#graph").append("svg")
		.attr("width", width + margin.left + margin.right)
		.attr("height", height + margin.top + margin.bottom)
		.append("g")
		.attr("transform", "translate( #{margin.left} , #{margin.top} )")
	line = d3.svg.line().x((d)->
		x d[trainLine]
	).y (d)->
		y d.income
	stations = data.filter((v)->
		v[trainLine]
	).map((v)->
		v[trainLine]=parseInt(v[trainLine],10)
		v.income=parseFloat(v.income,10)
		v
	).sort((a,b)->
		b[trainLine]-a[trainLine]
	)

	x.domain([1,d3.max(stations, (d)->
		parseInt d[trainLine], 10
	)]);
	y.domain([0,d3.max(stations, (d)->
		parseInt d.income, 10
	)])
	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0,#{height})")
		.call(xAxis).append("text").attr("y", 6).attr("x", 6)
		.attr("dx", ".71em")
		.attr("dy", "1.71em").style("text-anchor", "end")
		.text("stop number")
	svg.append("g")
		.attr("class", "y axis")
		.call(yAxis)
		.append("text")
		.attr("transform", "rotate(-90)")
		.attr("y", 6)
		.attr("dy", ".71em")
		.style("text-anchor", "end")
		.text("income $")
	svg.append("path")
		.datum(stations)
		.attr("class", "line")
		.attr("d", line)

d3.select('#line').on "change", ()->
	trainLine = document.getElementById("line").value
	d3.select("#graph svg").remove()
	makeGraph()

d3.csv "nodes.csv", (data) ->
	window.data = data
	makeGraph()

