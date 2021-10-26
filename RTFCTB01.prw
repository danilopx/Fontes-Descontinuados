#Include "Protheus.Ch"
#Include "Report.Ch"
#include "Rwmake.ch"
#include "Ap5mail.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Programa  ³ TFCTBR01 ³ Autor ³ Thiago Andre          ³ Data ³ 10/01/14 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Relacao de Debitos Contabeis              		    	    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³     Especifico Taiff                                       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function RTFCTB01()

	Local oReport

	If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Thiago Andre         ³ Data ³10/01/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³ Definicoes do Relatorio.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

	Local cAliasQry  	:= GetNextAlias()
	Local cPerg 		:= "RTFCTB01"
	Local oReport
	Local oSection1

	CriaSx1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := TReport():New("RTFCTB01","Relacao de Despesa Taiff.",cPerg, {|oReport| ReportPrint(oReport,cAliasQry)},;
		"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario. Despesas Contabeis")

	oReport:SetLandScape(.T.)
	oReport:SetTotalInLine(.F.) // Imprime o total em linhas

// Secao Principal
	oSection1 	:= TRSection():New(oReport,,{"CT2","CT1","CTT"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)

	TRCell():New(oSection1,"FILIAL"			,"CT2","Filial"				,/*Picture*/,TamSX3("CT2_FILIAL")[1]/*Tamanho*/,/*lPixel*/									,{|| (cAliasQry)->FILIAL })
	TRCell():New(oSection1,"FORNECEDOR" 	,"CT2","Fornecedor"			,/*Picture*/,TamSX3("CT2_HIST")[1],/*lPixel*/,{|| IIF(Substr((cAliasQry)->HISTORICO,1,3)="Doc",Substr((cAliasQry)->HISTORICO,18,24),IIF(Substr((cAliasQry)->HISTORICO,1,6)="Titulo",Substr((cAliasQry)->HISTORICO,25,24),(cAliasQry)->HISTORICO)) })
	TRCell():New(oSection1,"DT_LCTO"		,"CT2","Data Lcto."			,									,TamSX3("CT2_DATA")[1]	,/*lPixel*/	,{|| Stod((cAliasQry)->DT_LCTO) })
	TRCell():New(oSection1,"LOTE"			,"CT2","Lote Contabil"		,PesqPict("CT2","CT2_LOTE")		,TamSX3("CT2_LOTE")[1]	,/*lPixel*/	,{|| (cAliasQry)->LOTE })
	TRCell():New(oSection1,"SUB_LOTE"		,"CT2","Sub Lote"				,PesqPict("CT2","CT2_SBLOTE")	,TamSX3("CT2_SBLOTE")[1]	,/*lPixel*/	,{|| (cAliasQry)->SUB_LOTE })
	TRCell():New(oSection1,"DOC_CONTABIL"	,"CT2","Doc Contabil"		,PesqPict("CT2","CT2_DOC")		,TamSX3("CT2_DOC")[1]	,/*lPixel*/	,{|| (cAliasQry)->DOC_CONTABIL })
	TRCell():New(oSection1,"MOEDA"			,"CT2","Moeda"				,PesqPict("CT2","CT2_MOEDLC")	,TamSX3("CT2_MOEDLC")[1]	,/*lPixel*/	,{|| (cAliasQry)->MOEDA })
	TRCell():New(oSection1,"TIPO_LCTO"		,"CT2","Tipo Lcto."			,PesqPict("CT2","CT2_DC")		,TamSX3("CT2_DC")[1]		,/*lPixel*/	,{|| (cAliasQry)->TIPO_LCTO })
	TRCell():New(oSection1,"CTA_DEBITO"	,"CT2","Cta Debito."			,PesqPict("CT2","CT2_DEBITO")	,TamSX3("CT2_DEBITO")[1]	,/*lPixel*/	,{|| (cAliasQry)->CTA_DEBITO })
	TRCell():New(oSection1,"DESCRICAO"		,"CT1","Descricao"			,PesqPict("CT1","CT1_DESC01")	,TamSX3("CT1_DESC01")[1]	,/*lPixel*/	,{|| (cAliasQry)->DESCRICAO })
	TRCell():New(oSection1,"VALOR"			,"CT2","Valor"				,PesqPict("CT2","CT2_VALOR")	,TamSX3("CT2_VALOR")[1]	,/*lPixel*/	,{|| (cAliasQry)->VALOR })
	TRCell():New(oSection1,"HISTORICO"		,"CT2","Historico"			,PesqPict("CT2","CT2_HIST")		,TamSX3("CT2_HIST")[1]	,/*lPixel*/	,{|| (cAliasQry)->HISTORICO })
	TRCell():New(oSection1,"CCUSTO_DEB"	,"CT2","CCusto Debito"		,PesqPict("CT2","CT2_CCD")		,TamSX3("CT2_CCD")[1]	,/*lPixel*/	,{|| (cAliasQry)->CCUSTO_DEB })
	TRCell():New(oSection1,"CCUSTO_DESCR"	,"CTT","Descricao C Custo"	,PesqPict("CTT","CTT_DESC01")	,TamSX3("CTT_DESC01")[1]	,/*lPixel*/	,{|| (cAliasQry)->CCUSTO_DESC })

	oSection1:Cell("FILIAL"):SetHeaderAlign("RIGHT")
	oSection1:Cell("FORNECEDOR"):SetHeaderAlign("RIGHT")
	oSection1:Cell("DT_LCTO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("LOTE"):SetHeaderAlign("RIGHT")
	oSection1:Cell("SUB_LOTE"):SetHeaderAlign("RIGHT")
	oSection1:Cell("DOC_CONTABIL"):SetHeaderAlign("RIGHT")
	oSection1:Cell("MOEDA"):SetHeaderAlign("RIGHT")
	oSection1:Cell("TIPO_LCTO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("CTA_DEBITO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("DESCRICAO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("VALOR"):SetHeaderAlign("RIGHT")
	oSection1:Cell("HISTORICO"):SetHeaderAlign("RIGHT")
	oSection1:Cell("CCUSTO_DEB"):SetHeaderAlign("RIGHT")
	oSection1:Cell("CCUSTO_DESCR"):SetHeaderAlign("RIGHT")

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³ Autor ³ Thiago Andre          ³ Data ³01/01/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que imprime as linhas detalhes do relatorio            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasQry)

	Local aSRD 		:= {}
	Local cSaveArea
	Local cInicio	:= DtoS(mv_par01)
	Local cFim		:= DtoS(mv_par02)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()

	BeginSql Alias cAliasQry

		SELECT CT2_FILIAL AS FILIAL,
		CT2_DATA AS DT_LCTO,
		CT2_LOTE AS LOTE,
		CT2_SBLOTE AS 'SUB_LOTE',
		CT2_DOC AS 'DOC_CONTABIL',
		CT2_MOEDLC AS MOEDA,
		CT2_DC AS 'TIPO_LCTO',
		CT2_DEBITO AS 'CTA_DEBITO',
		CT1_DESC01 AS 'DESCRICAO',
		CT2_VALOR AS VALOR,
		CT2_HIST AS HISTORICO,
		CT2_CCD AS 'CCUSTO_DEB',
		CTT_DESC01 AS 'CCUSTO_DESC'
		FROM %Table:CT2% AS CT2
		INNER JOIN %Table:CT1% AS CT1
		ON CT1.%NotDel%
		AND CT2.CT2_DEBITO = CT1.CT1_CONTA
		LEFT JOIN %Table:CTT% AS CTT
		ON CTT.%NotDel%
		AND CT2.CT2_CCD = CTT_CUSTO
		WHERE
		CT2.%NotDel%
		AND CT2.CT2_DATA BETWEEN  %Exp:cInicio% AND %Exp:cFim%
		AND CT2.CT2_MOEDLC = '01'
		AND CT2.CT2_TPSALD = '1'
		AND CT2.CT2_DC IN ('1','3')
		ORDER BY CT2.CT2_FILIAL, CT2.CT2_DATA, CT2.CT2_LOTE, CT2.CT2_SBLOTE, CT2.CT2_DOC, CT2.CT2_LINHA, CT2.CT2_TPSALD, CT2.CT2_EMPORI, CT2.CT2_FILORI, CT2.CT2_MOEDLC
	
	EndSql

	oReport:Section(1):EndQuery()

//Imprimi Query no Servidor
	aSRD := GetLastQuery()
	Conout(aSRD[2])

	oReport:Section(1):Init()

	PQuery(cAliasQry,oReport) //Imprime

	oReport:Section(1):Finish()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PQuery	³ Autor ³ Jorge Tavares         ³ Data ³ 04/10/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para imprimir a Query				 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PQuery(cAliasQry,oReport)

	Local Section1  := oReport:Section(1)
	Local oBreak
	Local oBreak2

//oBreak := TRBreak():New(Section1, {||  Alltrim((cAliasQry)->CFOP) > "5000"   }/*Quebra*/,;
//{|| "Total por CFOP(s)... " /*  Iif ( ((cAliasQry)->D1_ITEMCTA = "PROART"), "Total PROART", IIF ( ((cAliasQry)->D1_ITEMCTA = "CORP"), "Total CORP" , "Total TAIFF")   )*/ })

//oBreak2 := TRBreak():New(Section1, {|| (cAliasQry)->ITEMCC }/*Quebra*/,	 {|| "Total por Unidade de Negocios " })

/*
//TRFunction():New(Section1:Cell("VALCONT"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("BASEICM"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("ICMS"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("BASEIPI"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("VALIPI"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("ICMSRET"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("TOTPROD"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("DESPESA"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("BASEPIS"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("VALPIS"),"","SUM",oBreak,,,,.F.,.F.)
//TRFunction():New(Section1:Cell("BASECOF"),"","SUM",oBreak,,,,.F.,.F.)
//TR8Function():New(Section1:Cell("VALCOF"),"","SUM",oBreak,,,,.F.,.F.)
*/

	dbSelectArea(cAliasQry)
	dBGotop()

	oReport:SetMeter((cAliasQry)->(LastRec()))

	Do While !(cAliasQry)->( Eof() )
	
		oReport:Section(1):PrintLine(.T.,.T.,.T.)
	
		(cAliasQry)->( DbSkip() )
		oReport:IncMeter()
	EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSx1   ºAutor  ³   	    		 º Data ³ OUT/2013    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para criaçao do grupo de perguntas	  		          º±±
±±º                  .				                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                            	              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(cPerg)

	Local aRegs := {}

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//MV_PAR01 - Periodo De
//MV_PAR02 - Periodo Ate
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


//Estrutura {Grupo	/Ordem	/Pergunta    	/Pergunta Espanhol	/Pergunta Ingles		/Variavel	/Tipo	/Tamanho/Decimal	/Presel	/GSC	     /Valid									  				/Var01	/Def01		/DefSpa1	/DefEng1	/Cnt01	/Var02	/Def02		/DefSpa2	/DefEng2	/Cnt02	/Var03	/Def03	/DefSpa3	/DefEng3	/Cnt03	/Var04	/Def04	/DefSpa4	/DefEng4	/Cnt04	/Var05	/Def05	/DefSpa5	/DefEng5	/Cnt05	/F3		/PYME	/GRPSX6	/HELP}
	Aadd(aRegs,{cPerg	,"01"	,"Periodo De   ? ", " Periodo De   ? "	,"Periodo De   ? " 		,"mv_ch1"	,"D"	, 08	,0			,0		,"G"	,"!Empty(MV_PAR01)"										,"mv_par01" ,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""	})
	Aadd(aRegs,{cPerg	,"02"	,"Periodo Ate  ? ", " Periodo Ate  ? "  ,"Periodo Ate  ? "		,"mv_ch2"	,"D"	, 08	,0			,0		,"G"	,"!Empty(MV_PAR02) .And. DTOS(MV_PAR02)>=DTOS(MV_PAR01)","mv_par02",""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""	})

	lValidPerg( aRegs )

Return
