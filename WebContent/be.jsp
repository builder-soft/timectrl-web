<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Bootstrap example</title>

<link
	href="${pageContext.request.contextPath}/bootstrap-334-dist/css/bootstrap.min.css"
	rel="stylesheet">

<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>

	<div class="container">

		<h1>Datos</h1>

		<div class="table-responsive">
			<table class="table table-condensed table-hover table-bordered table-striped">
				<thead>
					<tr>
						<th>#</th>
						<th>Firstname</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>1</td>
						<td>Anna</td>
					</tr>
					<tr>
						<td>2</td>
						<td>Debbie</td>
					</tr>
					<tr>
						<td>3</td>
						<td>John</td>
					</tr>
				</tbody>
			</table>
		</div>



	</div>


	<script
		src="${pageContext.request.contextPath}/plugin/jquery/1.11.3/jquery-1.11.3.js"></script>
	<script
		src="${pageContext.request.contextPath}/bootstrap-334-dist/js/bootstrap.min.js"></script>
</body>
</html>