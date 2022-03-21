<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>리스트 페이지</title>
<link rel="stylesheet" href="/style/style_Common.css">
</head>
<body>
	<div id="wrap">
		<header id="header">
			<h1>List 페이지</h1>
		</header>

		<nav id="gnb">
			<ul id="gnbUL" class="dFlex">
				<li class="gnbLi"><a href="/index.jsp">메인으로</a></li>
				<li class="gnbLi"><a href="#">로그인</a></li>
				<li class="gnbLi"><a href="#">글쓰기</a></li>
				<li class="gnbLi"><a href="/list/list.jsp">자유게시판 보기</a></li>
			</ul>
		</nav>

		<main id="main">
			<div id="main_header">
				<div id="main_info" class="dFlex">
					<div id="cntContent">
						전체 게시글 : <span id="cnt"></span>
					</div>
					<!-- div#cntContent -->

					<div id="curPage">
						페이지 : <span id="curPage"></span>/<span id="pages"></span>
					</div>
					<!-- div#curPage -->
				</div>
				<!-- div#main_info -->

				<ul id="main_content_title" class="dFlex">
					<li class="title">번호</li>
					<li class="title">제목</li>
					<li class="title">이름</li>
					<li class="title">날짜</li>
					<li class="title">조회수</li>
				</ul>
			</div>
			<!-- div#main_header -->

			<!-- 게시판 반복 구역 시작 -->
			<%
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;

			int curPageNum = 1;
			if (request.getParameter("pageNo") != null) {
				curPageNum = Integer.parseInt(request.getParameter("pageNo"));
			}

			int cnt = 0; //전체 페이지 갯수
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				String url = "jdbc:mysql://localhost:3306/listpage" + "?useUnicode=ture" + "&characterEncoding=UTF-8"
				+ "&useSSL=false" + "&serverTimezone=UTC";
				String user = "root";
				String password = "1234";
				conn = DriverManager.getConnection(url, user, password);

				String sql = "select count(no) from listbbs";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(sql);

				if (rs.next()) {
					cnt = rs.getInt("count(no)");
				}

				sql = "select * from listbbs where no between " + (cnt - (curPageNum) * 5 + 1) + " and "
				+ (cnt - (curPageNum - 1) * 5) + " order by no desc";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(sql);

				while (rs.next()) {
					int no = rs.getInt("no");
					String title = rs.getString("title");
					String name = rs.getString("name");
					String writeDate = rs.getDate("writeDate").toString();
					int viewCnt = rs.getInt("viewCnt");
			%>
			<div class="main_content dFlex">
				<div class="content_no"><%=no%></div>
				<div class="content_title">
					<a href="#"><%=title%></a>
				</div>
				<div class="content_name"><%=name%></div>
				<div class="content_date"><%=writeDate%></div>
				<div class="content_view"><%=viewCnt%></div>
			</div>
			<%
			}
			%>
			<div id="hidden" class="notView">
				<span id="hiddenCnt"><%=cnt%></span> <span id="hiddenPageNum"><%=curPageNum%></span>
			</div>
			<%
			// 데이터 셋 반환 영역 시작 끝
			rs.close();
			stmt.close();
			conn.close();

			} catch (ClassNotFoundException e) {
			out.print("CNFE : " + e.getMessage());
			} catch (SQLException e) {
			out.print("SQLE : " + e.getMessage());
			}
			%>
			<!-- 게시판 반복 구역 끝 -->
			<!-- div.main_content -->


			<div id="main_footer" class="dFlex">
				<div id="page_controller" class="dFlex">
					<%
					int pageNo = (int) Math.ceil((double) cnt / 5);
					int prevPage = curPageNum - 1;
					int nextPage = curPageNum + 1;
					if (curPageNum == 1) {
						prevPage = 1;
					}
					if (curPageNum == pageNo) {
						nextPage = pageNo;
					}
					%>
					<div id="leftBtn">
						<a href="/list/list.jsp?pageNo=<%=prevPage%>">&lt;</a>
					</div>

					<!-- class="currentPage" -->
					<%
					int firstPage = curPageNum - 2 < 1 ? curPageNum : curPageNum - 2;
					int lastPage = curPageNum + 2 >= pageNo ? pageNo : curPageNum + 2;
					if (curPageNum <= 3) {
						firstPage = 1;
						lastPage = 5;
					}
					for (int i = firstPage; i <= lastPage; i++) {
					%>
					<div class="pageNo" id="<%=i%>">
						<a href="/list/list.jsp?pageNo=<%=i%>"><%=i%></a>
					</div>
					<%
					}
					%>

					<div id="rightBtn">
						<a href="/list/list.jsp?pageNo=<%=nextPage%>">&gt;</a>
					</div>
				</div>
				<!-- div#page_controller -->

				<div id="search">
					<select name="order" id="selectBox">
						<option value="title">제 목</option>
						<option value="name">이 름</option>
						<option value="content">내 용</option>
					</select> <input type="text" id="search_input" name="search_input">
					<button id="btn">검색</button>
				</div>
				<!-- div#search -->
			</div>
			<!-- div#main_footer -->
		</main>

	</div>
	<!--div#wrap-->
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/script/script.js"></script>
</body>
</html>