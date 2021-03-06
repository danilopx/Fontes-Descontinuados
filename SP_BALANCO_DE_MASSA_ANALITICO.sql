USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_ANALITICO]    Script Date: 10/08/2021 17:42:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_ANALITICO	  								  *
* OBJETIVO  : VIsão analitica do Processo gerador do BM						  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 26/03/2014                                                      *
* OBSERVACAO:                                                                 * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_ANALITICO]
AS
BEGIN
	--SELECT * FROM TEMP_ANALITICO_BM_DAIHATSU_SP
	--UNION ALL
	--SELECT * FROM TEMP_ANALITICO_BM_DAIHATSU
	--UNION ALL
	--SELECT * FROM TEMP_ANALITICO_BM_MERCABEL_SP
	--UNION ALL
	--SELECT * FROM TEMP_ANALITICO_BM_MERCABEL
	--UNION ALL
	--SELECT * FROM TEMP_ANALITICO_BM_ACTION_VARGINHA
	--UNION ALL
	--SELECT * FROM TEMP_ANALITICO_BM_PROART_EXTREMA
	--UNION ALL
	--SELECT * FROM TEMP_ANALITICO_BM_PROART_FILIAL
	--UNION ALL
	--SELECT * FROM TEMP_ANALITICO_BM_PROART
	--
	-- Modelo novo determinado em 09/2017 - Solicitante: DOUGLAS RODRIGUES FORNAZIER
	--
	--
	-- EMPRESA 01 E FILIAIS
	-- 
	SELECT 
		CASE B2_FILIAL WHEN '01' THEN 'DAIHATSU - MATRIZ' WHEN '02' THEN 'DAIHATSU - NACOES UNIDAS' ELSE '' END AS EMPRESA
		,B2_COD AS PRODUTO
		,RTRIM(LTRIM(B1_DESC)) AS DESCRICAO_PRODUTO
		,B2_LOCAL AS ARMAZEM
		,ISNULL((SELECT NM_ARMAZ FROM TBL_NOME_ARMAZENS WHERE ID_ARMAZ=B2_LOCAL),'') AS NOME_ARMAZEM
		,'L' AS L_T
		,B2_QATU AS QTDE
		,ISNULL((SELECT B9_CM1 FROM SB9010 SB9 WHERE B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B2_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) AS CUSTO_UNITARIO
		,(ISNULL((SELECT B9_CM1 FROM SB9010 SB9 WHERE B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B2_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) * B2_QATU) AS CUSTO_TOTAL
	FROM SB2010 SB2 WITH(NOLOCK) 
	INNER JOIN SB1010 SB1 WITH(NOLOCK) 
	ON B1_COD=B2_COD
	AND SB1.D_E_L_E_T_=''
	WHERE SB2.D_E_L_E_T_=''
	AND B2_QATU != 0
	AND B2_LOCAL != '31'
	UNION ALL
	SELECT
		EMPRESA
		,PRODUTO
		,DESCRICAO_PRODUTO
		,ARMAZEM
		,NOME_ARMAZEM
		,L_T AS L_T
		,SUM(QTDE) AS QTDE
		,CUSTO_UNITARIO
		,SUM(QTDE) * CUSTO_UNITARIO AS CUSTO_TOTAL
	FROM 
	(
		SELECT 
			CASE B6_FILIAL WHEN '01' THEN 'DAIHATSU - MATRIZ' WHEN '02' THEN 'DAIHATSU - NACOES UNIDAS' ELSE 'DAIHATSU' END AS EMPRESA
			,B6_PRODUTO AS PRODUTO
			,RTRIM(LTRIM(B1_DESC)) AS DESCRICAO_PRODUTO
			,B6_LOCAL AS ARMAZEM
			,ISNULL((SELECT NM_ARMAZ FROM TBL_NOME_ARMAZENS WHERE ID_ARMAZ=B6_LOCAL),'') AS NOME_ARMAZEM
			,'T' AS L_T
			,B6_SALDO AS QTDE
			,ISNULL((SELECT B9_CM1 FROM SB9010 SB9 WHERE B9_FILIAL=B6_FILIAL AND B9_COD=B6_PRODUTO AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B6_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) AS CUSTO_UNITARIO
			,0 AS CUSTO_TOTAL
		FROM SB6010 SB6 WITH(NOLOCK) 
		INNER JOIN SB1010 SB1 WITH(NOLOCK) 
		ON B1_COD=B6_PRODUTO
		AND SB1.D_E_L_E_T_=''
		WHERE SB6.D_E_L_E_T_=''
		AND B6_SALDO != 0
	) AUX
	GROUP BY EMPRESA,PRODUTO,DESCRICAO_PRODUTO,ARMAZEM,NOME_ARMAZEM,L_T ,CUSTO_UNITARIO
	--
	--
	UNION ALL
	--
	-- EMPRESA 02 E FILIAIS
	-- 
	SELECT 
		CASE B2_FILIAL WHEN '01' THEN 'MERCABEL - MATRIZ' WHEN '02' THEN 'MERCABEL - ITUMBIARA' ELSE '' END AS EMPRESA
		,B2_COD AS PRODUTO
		,RTRIM(LTRIM(B1_DESC)) AS DESCRICAO_PRODUTO
		,B2_LOCAL AS ARMAZEM
		,ISNULL((SELECT NM_ARMAZ FROM TBL_NOME_ARMAZENS WHERE ID_ARMAZ=B2_LOCAL),'') AS NOME_ARMAZEM
		,'L' AS L_T
		,B2_QATU AS QTDE
		,ISNULL((SELECT B9_CM1 FROM SB9020 SB9 WHERE B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B2_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) AS CUSTO_UNITARIO
		,(ISNULL((SELECT B9_CM1 FROM SB9020 SB9 WHERE B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B2_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) * B2_QATU) AS CUSTO_TOTAL
	FROM SB2020 SB2 WITH(NOLOCK) 
	INNER JOIN SB1020 SB1 WITH(NOLOCK) 
	ON B1_COD=B2_COD
	AND SB1.D_E_L_E_T_=''
	WHERE SB2.D_E_L_E_T_=''
	AND B2_QATU != 0
	AND B2_LOCAL != '31'
	UNION ALL
	SELECT
		EMPRESA
		,PRODUTO
		,DESCRICAO_PRODUTO
		,ARMAZEM
		,NOME_ARMAZEM
		,L_T AS L_T
		,SUM(QTDE) AS QTDE
		,CUSTO_UNITARIO
		,SUM(QTDE) * CUSTO_UNITARIO AS CUSTO_TOTAL
	FROM 
	(
		SELECT 
			CASE B6_FILIAL WHEN '01' THEN 'MERCABEL - MATRIZ' WHEN '02' THEN 'MERCABEL - ITUMBIARA' ELSE '' END AS EMPRESA
			,B6_PRODUTO AS PRODUTO
			,RTRIM(LTRIM(B1_DESC)) AS DESCRICAO_PRODUTO
			,B6_LOCAL AS ARMAZEM
			,ISNULL((SELECT NM_ARMAZ FROM TBL_NOME_ARMAZENS WHERE ID_ARMAZ=B6_LOCAL),'') AS NOME_ARMAZEM
			,'T' AS L_T
			,B6_SALDO AS QTDE
			,ISNULL((SELECT B9_CM1 FROM SB9020 SB9 WHERE B9_FILIAL=B6_FILIAL AND B9_COD=B6_PRODUTO AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B6_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) AS CUSTO_UNITARIO
			,0 AS CUSTO_TOTAL
		FROM SB6020 SB6 WITH(NOLOCK) 
		INNER JOIN SB1020 SB1 WITH(NOLOCK) 
		ON B1_COD=B6_PRODUTO
		AND SB1.D_E_L_E_T_=''
		WHERE SB6.D_E_L_E_T_=''
		AND B6_SALDO != 0
	) AUX
	GROUP BY EMPRESA,PRODUTO,DESCRICAO_PRODUTO,ARMAZEM,NOME_ARMAZEM,L_T ,CUSTO_UNITARIO
	--
	--
	UNION ALL
	--
	-- EMPRESA 03 E FILIAIS
	-- 
	SELECT 
		CASE B2_FILIAL WHEN '01' THEN 'TAIFFPROART - MATRIZ' WHEN '02' THEN 'TAIFFPROART - EXTREMA' WHEN '03' THEN 'TAIFFPROART - BARUERI' ELSE '' END AS EMPRESA
		,B2_COD AS PRODUTO
		,RTRIM(LTRIM(B1_DESC)) AS DESCRICAO_PRODUTO
		,B2_LOCAL AS ARMAZEM
		,ISNULL((SELECT NM_ARMAZ FROM TBL_NOME_ARMAZENS WHERE ID_ARMAZ=B2_LOCAL),'') AS NOME_ARMAZEM
		,'L' AS L_T
		,B2_QATU AS QTDE
		,ISNULL((SELECT B9_CM1 FROM SB9030 SB9 WHERE B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B2_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) AS CUSTO_UNITARIO
		,(ISNULL((SELECT B9_CM1 FROM SB9030 SB9 WHERE B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B2_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) * B2_QATU) AS CUSTO_TOTAL
	FROM SB2030 SB2 WITH(NOLOCK) 
	INNER JOIN SB1030 SB1 WITH(NOLOCK) 
	ON B1_COD=B2_COD
	AND SB1.D_E_L_E_T_=''
	AND B1_FILIAL=B2_FILIAL
	WHERE SB2.D_E_L_E_T_=''
	AND B2_QATU != 0
	AND B2_LOCAL != '31'
	UNION ALL
	SELECT
		EMPRESA
		,PRODUTO
		,DESCRICAO_PRODUTO
		,ARMAZEM
		,NOME_ARMAZEM
		,L_T AS L_T
		,SUM(QTDE) AS QTDE
		,CUSTO_UNITARIO
		,SUM(QTDE) * CUSTO_UNITARIO AS CUSTO_TOTAL
	FROM 
	(
		SELECT 
			CASE B6_FILIAL WHEN '01' THEN 'TAIFFPROART - MATRIZ' WHEN '02' THEN 'TAIFFPROART - EXTREMA' WHEN '03' THEN 'TAIFFPROART - BARUERI' ELSE '' END AS EMPRESA
			,B6_PRODUTO AS PRODUTO
			,RTRIM(LTRIM(B1_DESC)) AS DESCRICAO_PRODUTO
			,B6_LOCAL AS ARMAZEM
			,ISNULL((SELECT NM_ARMAZ FROM TBL_NOME_ARMAZENS WHERE ID_ARMAZ=B6_LOCAL),'') AS NOME_ARMAZEM
			,'T' AS L_T
			,B6_SALDO AS QTDE
			,ISNULL((SELECT B9_CM1 FROM SB9030 SB9 WHERE B9_FILIAL=B6_FILIAL AND B9_COD=B6_PRODUTO AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B6_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) AS CUSTO_UNITARIO
			,0 AS CUSTO_TOTAL
		FROM SB6030 SB6 WITH(NOLOCK) 
		INNER JOIN SB1030 SB1 WITH(NOLOCK) 
		ON B1_COD=B6_PRODUTO
		AND SB1.D_E_L_E_T_=''
		AND B1_FILIAL=B6_FILIAL
		WHERE SB6.D_E_L_E_T_=''
		AND B6_SALDO != 0
	) AUX
	GROUP BY EMPRESA,PRODUTO,DESCRICAO_PRODUTO,ARMAZEM,NOME_ARMAZEM,L_T ,CUSTO_UNITARIO
	--
	--
	UNION ALL
	--
	-- EMPRESA 04 E FILIAIS
	-- 
	SELECT 
		CASE B2_FILIAL WHEN '01' THEN 'ACTION - INDAIATUBA' WHEN '02' THEN 'ACTION - VARGINHA' ELSE '' END AS EMPRESA
		,B2_COD AS PRODUTO
		,RTRIM(LTRIM(B1_DESC)) AS DESCRICAO_PRODUTO
		,B2_LOCAL AS ARMAZEM
		,ISNULL((SELECT NM_ARMAZ FROM TBL_NOME_ARMAZENS WHERE ID_ARMAZ=B2_LOCAL),'') AS NOME_ARMAZEM
		,'L' AS L_T
		,B2_QATU AS QTDE
		,ISNULL((SELECT B9_CM1 FROM SB9040 SB9 WHERE B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B2_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) AS CUSTO_UNITARIO
		,(ISNULL((SELECT B9_CM1 FROM SB9040 SB9 WHERE B9_FILIAL=B2_FILIAL AND B9_COD=B2_COD AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B2_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) * B2_QATU) AS CUSTO_TOTAL
	FROM SB2040 SB2 WITH(NOLOCK) 
	INNER JOIN SB1040 SB1 WITH(NOLOCK) 
	ON B1_COD=B2_COD
	AND SB1.D_E_L_E_T_=''
	AND B1_FILIAL=B2_FILIAL
	WHERE SB2.D_E_L_E_T_=''
	AND B2_QATU != 0
	AND B2_LOCAL != '31'
	UNION ALL
	SELECT
		EMPRESA
		,PRODUTO
		,DESCRICAO_PRODUTO
		,ARMAZEM
		,NOME_ARMAZEM
		,L_T AS L_T
		,SUM(QTDE) AS QTDE
		,CUSTO_UNITARIO
		,SUM(QTDE) * CUSTO_UNITARIO AS CUSTO_TOTAL
	FROM 
	(
		SELECT 
			CASE B6_FILIAL WHEN '01' THEN 'ACTION - INDAIATUBA' WHEN '02' THEN 'ACTION - VARGINHA' ELSE '' END AS EMPRESA
			,B6_PRODUTO AS PRODUTO
			,RTRIM(LTRIM(B1_DESC)) AS DESCRICAO_PRODUTO
			,B6_LOCAL AS ARMAZEM
			,ISNULL((SELECT NM_ARMAZ FROM TBL_NOME_ARMAZENS WHERE ID_ARMAZ=B6_LOCAL),'') AS NOME_ARMAZEM
			,'T' AS L_T
			,B6_SALDO AS QTDE
			,ISNULL((SELECT B9_CM1 FROM SB9040 SB9 WHERE B9_FILIAL=B6_FILIAL AND B9_COD=B6_PRODUTO AND SB9.D_E_L_E_T_='' AND B9_LOCAL=B6_LOCAL AND B9_DATA>=CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE() - DAY(GETDATE()) ) ,112)),0) AS CUSTO_UNITARIO
			,0 AS CUSTO_TOTAL
		FROM SB6040 SB6 WITH(NOLOCK) 
		INNER JOIN SB1040 SB1 WITH(NOLOCK) 
		ON B1_COD=B6_PRODUTO
		AND SB1.D_E_L_E_T_=''
		AND B1_FILIAL=B6_FILIAL
		WHERE SB6.D_E_L_E_T_=''
		AND B6_SALDO != 0
	) AUX
	GROUP BY EMPRESA,PRODUTO,DESCRICAO_PRODUTO,ARMAZEM,NOME_ARMAZEM,L_T ,CUSTO_UNITARIO

	ORDER BY EMPRESA,PRODUTO,ARMAZEM,L_T


END