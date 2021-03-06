USE [DADOSPRO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BALANCO_DE_MASSA_DROP_TEMP]    Script Date: 10/08/2021 17:12:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************
* PROCEDURE : SP_BALANCO_DE_MASSA_DROP_TEMP			  						  *
* OBJETIVO  : DROP de tabelas temporarias do BM								  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 26/03/2014                                                      *
* OBSERVACAO: Executado SCHEDULE do PROTHEUS fonte principal TFEXECBM         * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_BALANCO_DE_MASSA_DROP_TEMP]
AS
BEGIN

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_PROART'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_PROART
	END

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_PROART_EXTREMA'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_PROART_EXTREMA
	END

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_PROART_FILIAL'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_PROART_FILIAL
	END

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_DAIHATSU'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_DAIHATSU
	END

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_DAIHATSU_SP'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_DAIHATSU_SP
	END

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_MERCABEL'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_MERCABEL
	END

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_MERCABEL_SP'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_MERCABEL_SP
	END

	IF ISNULL(OBJECT_ID('TEMP_ANALITICO_BM_ACTION_VARGINHA'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_ANALITICO_BM_ACTION_VARGINHA
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_DAIHATSU_FILIAL_01'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_DAIHATSU_FILIAL_01
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_PROART'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_PROART
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_MERCABEL_SP'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_MERCABEL_SP
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_MERCABEL'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_MERCABEL
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_PROART_EXTREMA'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_PROART_EXTREMA
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_PROART_FILIAIS'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_PROART_FILIAIS
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_ACTION'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_ACTION
	END

	IF ISNULL(OBJECT_ID('TEMP_MOVIMENTOS_BM_ACTION_VARGINHA'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_MOVIMENTOS_BM_ACTION_VARGINHA
	END

	IF ISNULL(OBJECT_ID('TEMP_RESUMO_BM'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_RESUMO_BM
	END

	IF ISNULL(OBJECT_ID('TEMP_RESUMO_BM_PROART'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_RESUMO_BM_PROART
	END

	IF ISNULL(OBJECT_ID('TEMP_SEMAFARO_BM'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_SEMAFARO_BM
	END
	
	IF ISNULL(OBJECT_ID('TEMP_RESUMO_CT'), 0) <> 0
	BEGIN
		DROP TABLE TEMP_RESUMO_CT
	END


END
