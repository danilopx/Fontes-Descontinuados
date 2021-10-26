#Include 'rwmake.ch'
#include "protheus.ch"
#include "topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TFPCPOEE  ºAutor  ³Carlos Torres       º Data ³  30/01/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de impressão de relatórios de apontamento           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TFPCPOEE()
	Private oGeraNf
	Private cPerg		:= "TFPCPaph"
	Private cCadastro := "Apontamento Hora"
	Private oReport

	AjustaSx1( "TFPCPaph" )

	If Pergunte("TFPCPaph",.T.)
		oReport := DReportDef()
		oReport:PrintDialog()
	EndIf

Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Perguntas do relatório
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)
	Local cKey 		:= ""
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}

	Aadd( aHelpPor, "Data do Apontamento" )
	Aadd( aHelpEng, "Data do Apontamento" )
	Aadd( aHelpSpa, "Data do Apontamento" )

	PutSx1(cPerg,"01"   ,"Data do Apontamento?","",""	,"mv_ch1","D",08,0,0,"G","","",,,;
		"mv_par01", "","","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	//"","","",".TFSEPTAI.")

	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {}

	Aadd( aHelpPor, "Informe o código operador especifico" )
	Aadd( aHelpEng, "Informe o código operador especifico" )
	Aadd( aHelpSpa, "Informe o código operador especifico" )

	PutSx1(cPerg,"02"   ,"Operador?","",""	,"mv_ch2","C",10,0,0,"G","","","","",;
		"mv_par02","","","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	//"","","",".TFSEPTAI.")

Return

/*
--------------------------------------------------------------------------------------------------------------
Função Static de preparação dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportDef()
	Local oReport
	Local cAliasQry := "TSQLPOEE"
	Local oOSTransf_1
	Local oOSTransf_2
	Local oOSTransf_3

	PRIVATE CTFOPE1 := ""
	PRIVATE CTFOPE2 := ""
	PRIVATE CTFOPE3 := ""
	PRIVATE CTFOPE4 := ""

	oReport := TReport():New("TFPCPOEE","Apontamento Hora - hora","TFPCPOEE", {|oReport| DReportPrint(oReport,cAliasQry)},"")
	oReport:SetLandscape()
	oReport:SetTotalInLine(.T.)

	Pergunte(oReport:uParam,.F.)

	oOSTransf_1 := TRSection():New(oReport,"Apontamento Hora - Hora",{"CBH"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oOSTransf_1:SetTotalInLine(.F.)
	oOSTransf_1:SetPageBreak(.T.)

	TRCell():New(oOSTransf_1,"CBH_DATAAPO"	,"CBH"	,"Data"				,PesqPict("CBH","CBH_DTFIM")	,10							,/*lPixel*/,{|| (cAliasQry)->CBH_DATAAPO	})
	TRCell():New(oOSTransf_1,"CBH_CELULA"	,"CBH"	,"Celula"			,PesqPict("CBH","CBH_RECUR")	,TamSx3("CBH_RECUR")[1]	,/*lPixel*/,{|| (cAliasQry)->CBH_CELULA		})
	TRCell():New(oOSTransf_1,"CBH_IDLIDER"	,"CBH"	,"Lider"			,"@!"							,20							,/*lPixel*/,{|| (cAliasQry)->CBH_IDLIDER	})

	oOSTransf_2 := TRSection():New(oReport,"CELULA",{"CBH"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oOSTransf_2:SetTotalInLine(.T.)

	TRCell():New(oOSTransf_2,"CBH_HORRANG"		,"CBH"	,"Hora        "	,"@!"								,07							,/*lPixel*/,{|| (cAliasQry)->CBH_HORRANG	})
	TRCell():New(oOSTransf_2,"CBH_MTABH"		,"CBH"	,"Meta Habil. "	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CBH_MTABH		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"CBH_MTPAD"		,"CBH"	,"Meta Padrao "	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CBH_MTPAD		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"CBH_PRO1"			,"CBH"	,"1o. Operador"	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CBH_PRO1		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"CBH_PRO2"			,"CBH"	,"2o. Operador"	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CBH_PRO2		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"CBH_PRO3"			,"CBH"	,"3o. Operador"	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CBH_PRO3		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"CBH_PRO4"			,"CBH"	,"4o. Operador"	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CBH_PRO4		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"CBH_PRODUZ"		,"CBH"	,"Tot.p/Hr.   "	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CBH_PRODUZ		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"CBH_QTOPERA"		,"CBH"	,"Qtd.Oper.   "	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CBH_QTOPERA	},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"CBH_PRODUTO"		,"CBH"	,"Produto     "	,PesqPict("SB1","B1_COD")			,TamSx3("B1_COD")[1]		,/*lPixel*/,{|| (cAliasQry)->CBH_PRODUTO	})
	TRCell():New(oOSTransf_2,"NOME_PRODUTO"		,"CBH"	,"Descriçao   "	,"@!"								,30							,/*lPixel*/,{|| (cAliasQry)->NOME_PRODUTO	})

	oOSTransf_3 := TRSection():New(oReport,"TOTAIS",{"CBH"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	TRCell():New(oOSTransf_3,"Totais"			,		,"Hora        "	,									,07)
	TRCell():New(oOSTransf_3,"CBH_MTA1"			,		,"Meta Habil. "	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_3,"CBH_MTP1"			,		,"Meta Padrao "	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_3,"CBH_PRO1"			,		,"1o. Operador"	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_3,"CBH_PRO2"			,		,"2o. Operador"	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_3,"CBH_PRO3"			,		,"3o. Operador"	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_3,"CBH_PRO4"			,		,"4o. Operador"	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_3,"CBH_PRODUZ"		,		,"Tot.p/Hr.   "	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_3,"CBH_QTOPERA"		,		,"Qtd.Oper.   "	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")

	oOSTransf_3:Cell("Totais"):HideHeader()
	oOSTransf_3:Cell("CBH_MTA1"):HideHeader()
	oOSTransf_3:Cell("CBH_MTP1"):HideHeader()
	oOSTransf_3:Cell("CBH_PRO1"):HideHeader()
	oOSTransf_3:Cell("CBH_PRO2"):HideHeader()
	oOSTransf_3:Cell("CBH_PRO3"):HideHeader()
	oOSTransf_3:Cell("CBH_PRO4"):HideHeader()
	oOSTransf_3:Cell("CBH_PRODUZ"):HideHeader()
	oOSTransf_3:Cell("CBH_QTOPERA"):HideHeader()

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Função Static de execução do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportPrint(oReport,cAliasQry)
	Local __QuebraOC

	oReport:SetTitle(oReport:Title() )
	oReport:Section(1):SetHeaderPage(.T.)
	oReport:Section(1):SetHeaderSection(.T.)
	oReport:Section(1):SetHeaderBreak(.F.)

	MakeSqlExpr(oReport:uParam)

	If TCSPExist("SP_REL_PCP_SINTETICO_APONTAMENTO_HORAS")

		_cQuery := "EXEC SP_REL_PCP_SINTETICO_APONTAMENTO_HORAS '" + DTOS(MV_PAR01) + "' , '" + CFILANT + "' ,'" + MV_PAR02 + "' "

		If Select(cAliasQry) > 0
			dbSelectArea(cAliasQry)
			DbCloseArea()
		EndIf

		TCQUERY _cQuery NEW ALIAS "TSQLPOEE"
	Else
		Final("RE-INSTALAR A STORED PROCEDURE: SP_REL_PCP_SINTETICO_APONTAMENTO_HORAS")
	EndIf

	oReport:Section(1):BeginQuery()
	dbSelectArea("TSQLPOEE")
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter((cAliasQry)->(LastRec()))
	dbSelectArea(cAliasQry)

	While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

		cDtQuebra := (cAliasQry)->CBH_DATAAPO
		cClQuebra := (cAliasQry)->CBH_CELULA

		_nTotPr1 := 0
		_nTotPr2 := 0
		_nTotPr3 := 0
		_nTotPr4 := 0
		_nTotMTA := 0
		_nTotMTP := 0

		oReport:Section(1):Init()
		oReport:Section(1):PrintLine()
		oReport:Section(2):Init()
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .and. (cAliasQry)->CBH_DATAAPO = cDtQuebra .and. (cAliasQry)->CBH_CELULA = cClQuebra

			oReport:Section(2):PrintLine()
			_nTotPr1 += (cAliasQry)->CBH_PRO1
			_nTotPr2 += (cAliasQry)->CBH_PRO2
			_nTotPr3 += (cAliasQry)->CBH_PRO3
			_nTotPr4 += (cAliasQry)->CBH_PRO4
			_nTotMTA += (cAliasQry)->CBH_MTABH
			_nTotMTP += (cAliasQry)->CBH_MTPAD

			dbSkip()
			oReport:IncMeter()
		End

		oReport:Section(3):Init()
		oReport:Section(3):Cell( "Totais" ):SetBlock( { || "TOTAL" } ) // "TOTAL GERAL"
		oReport:Section(3):Cell("CBH_MTA1"):SetBlock( { || _nTotMTA } )
		oReport:Section(3):Cell("CBH_MTP1"):SetBlock( { || _nTotMTP } )
		oReport:Section(3):Cell("CBH_PRO1"):SetBlock( { || _nTotPr1 } )
		oReport:Section(3):Cell("CBH_PRO2"):SetBlock( { || _nTotPr2 } )
		oReport:Section(3):Cell("CBH_PRO3"):SetBlock( { || _nTotPr3 } )
		oReport:Section(3):Cell("CBH_PRO4"):SetBlock( { || _nTotPr4 } )
		oReport:Section(3):Cell("CBH_PRODUZ"):SetBlock( { || _nTotPr1 + _nTotPr2 + _nTotPr3 + _nTotPr4 } )

		oReport:Section(3):PrintLine()
		oReport:Section(3):Finish()
		oReport:Section(2):Finish()
		oReport:Section(1):Finish()

	End
Return