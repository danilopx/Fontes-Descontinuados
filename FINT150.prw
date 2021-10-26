#Include 'Protheus.ch'
#INCLUDE "FINT150.CH"
#Include "PROTHEUS.Ch"
#INCLUDE "FWCOMMAND.CH"

#DEFINE QUEBR				1
#DEFINE FORNEC				2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO			6
#DEFINE VENCTO				7
#DEFINE VENCREA			8
#DEFINE VL_ORIG			9
#DEFINE VL_NOMINAL		10
#DEFINE VL_CORRIG			11
#DEFINE VL_VENCIDO		12
#DEFINE PORTADOR			13
#DEFINE VL_JUROS			14
#DEFINE ATRASO				15
#DEFINE HISTORICO			16
#DEFINE VL_SOMA			17

Static lFWCodFil := FindFunction("FWCodFil")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FIN150	³ Autor ³ Daniel Tadashi Batori ³ Data ³ 07.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posi‡„o dos Titulos a Pagar					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR150(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FINT150()


Local oReport  

Private cTitAux := ""    // Guarda o titulo do relatório para R3 e R4 

/*
GESTAO - inicio */
Private aSelFil	:= {}
/* GESTAO - fim
 */

AjustaSx1()
 
If FindFunction("TRepInUse") .And. TRepInUse() .and. !IsBlind()
	oReport := ReportDef()
	oReport:PrintDialog()
//Else
//	Return FINR150R3() // Executa versão anterior do fonte
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Daniel Batori         ³ Data ³ 07.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do layout do Relatorio									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local cPictTit
Local nTamVal, nTamCli, nTamQueb
//Local cPerg := Padr("FIN150",Len(SX1->X1_GRUPO))
Local aOrdem := {STR0008,;	//"Por Numero"
				 STR0009,;	//"Por Natureza"
				 STR0010,;	//"Por Vencimento"
				 STR0011,;	//"Por Banco"
				 STR0012,;	//"Fornecedor"
				 STR0013,;	//"Por Emissao"
				 STR0014}	//"Por Cod.Fornec."

oReport := TReport():New("FINR150",STR0005,"FIN150",{|oReport| ReportPrint(oReport)},STR0001+STR0002)

oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)		//Imprime o total em linha

/*
GESTAO - inicio */
oReport:SetUseGC(.F.)
/* GESTAO - fim
*/

//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

dbSelectArea("SX1")

pergunte("FIN150",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01	  // do Numero 			  ³
//³ mv_par02	  // at‚ o Numero 		  ³
//³ mv_par03	  // do Prefixo			  ³
//³ mv_par04	  // at‚ o Prefixo		  ³
//³ mv_par05	  // da Natureza  	     ³
//³ mv_par06	  // at‚ a Natureza		  ³
//³ mv_par07	  // do Vencimento		  ³
//³ mv_par08	  // at‚ o Vencimento	  ³
//³ mv_par09	  // do Banco			     ³
//³ mv_par10	  // at‚ o Banco		     ³
//³ mv_par11	  // do Fornecedor		  ³
//³ mv_par12	  // at‚ o Fornecedor	  ³
//³ mv_par13	  // Da Emiss„o			  ³
//³ mv_par14	  // Ate a Emiss„o		  ³
//³ mv_par15	  // qual Moeda			  ³
//³ mv_par16	  // Imprime Provis¢rios  ³
//³ mv_par17	  // Reajuste pelo vencto ³
//³ mv_par18	  // Da data contabil	  ³
//³ mv_par19	  // Ate data contabil	  ³
//³ mv_par20	  // Imprime Rel anal/sint³
//³ mv_par21	  // Considera  Data Base?³
//³ mv_par22	  // Cons filiais abaixo ?³
//³ mv_par23	  // Filial de            ³
//³ mv_par24	  // Filial ate           ³
//³ mv_par25	  // Loja de              ³
//³ mv_par26	  // Loja ate             ³
//³ mv_par27 	  // Considera Adiantam.? ³
//³ mv_par28	  // Imprime Nome 		  ³
//³ mv_par29	  // Outras Moedas 		  ³
//³ mv_par30     // Imprimir os Tipos    ³
//³ mv_par31     // Nao Imprimir Tipos	  ³
//³ mv_par32     // Consid. Fluxo Caixa  ³
//³ mv_par33     // DataBase             ³
//³ mv_par34     // Tipo de Data p/Saldo ³
//³ mv_par35     // Quanto a taxa		  ³
//³ mv_par36     // Tit.Emissao Futura	  ³
//³ mv_par37     // Seleciona filiais (GESTAO)
//³ mv_par38     // Considera Tit Exclu³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPictTit := PesqPict("SE2","E2_VALOR")
If cPaisLoc == "CHI"
	cPictTit := SubStr(cPictTit,1,At(".",cPictTit)-1)
EndIf   

nTamVal	 := TamSX3("E2_VALOR")[1]
nTamCli	 := TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1] + 25
nTamTit	 := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + 8
nTamQueb := nTamCli + nTamTit + TamSX3("E2_TIPO")[1] + TamSX3("E2_NATUREZ")[1] + TamSX3("E2_EMISSAO")[1] +;
			TamSX3("E2_VENCTO")[1] + TamSX3("E2_VENCREA")[1] + 14
			
//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,STR0061,{"SE2","SA2"},aOrdem)

TRCell():New(oSection1,"FORNECEDOR"	,	  ,STR0038				,,nTamCli,.F.,)  		//"Codigo-Nome do Fornecedor"
TRCell():New(oSection1,"TITULO"		,	  ,STR0039+CRLF+STR0040	,,nTamTit,.F.,)  		//"Prf-Numero" + "Parcela"
TRCell():New(oSection1,"E2_TIPO"	,"SE2",STR0041				,,,.F.,)  				//"TP"
TRCell():New(oSection1,"E2_NATUREZ"	,"SE2",STR0042				,,TamSX3("E2_NATUREZ")[1] + 5,.F.,)  				//"Natureza"
TRCell():New(oSection1,"E2_EMISSAO"	,"SE2",STR0043+CRLF+STR0044	,,,.F.,) 				//"Data de" + "Emissao"
TRCell():New(oSection1,"E2_VENCTO"	,"SE2",STR0043+CRLF+STR0045	,,,.F.,)  				//"Vencto" + "Titulo"
TRCell():New(oSection1,"E2_VENCREA"	,"SE2",STR0045+CRLF+STR0047	,,,.F.,)  				//"Vencto" + "Real"
TRCell():New(oSection1,"VAL_ORIG"	,	  ,STR0048				,cPictTit,nTamVal+3,.F.,) //"Valor Original"
TRCell():New(oSection1,"VAL_NOMI"	,	  ,STR0049+CRLF+STR0050	,cPictTit,nTamVal+3,.F.,) //"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection1,"VAL_CORR"	,	  ,STR0049+CRLF+STR0051	,cPictTit,nTamVal+3,.F.,) //"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection1,"VAL_VENC"	,	  ,STR0052+CRLF+STR0050	,cPictTit,nTamVal+3,.F.,) //"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection1,"E2_PORTADO"	,"SE2",STR0053+CRLF+STR0054	,,,.F.,)  				//"Porta-" + "dor"
TRCell():New(oSection1,"JUROS"		,	  ,STR0055+CRLF+STR0056	,cPictTit,nTamVal+3,.F.,) //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"DIA_ATR"	,	  ,STR0057+CRLF+STR0058	,,4,.F.,)  				//"Dias" + "Atraso"
TRCell():New(oSection1,"E2_HIST"	,"SE2",IIf(cPaisloc =="MEX",STR0063,STR0059) ,,35,.F.,)  			//"Historico(Vencidos+Vencer)"
TRCell():New(oSection1,"VAL_SOMA"	,	  ,STR0060				,cPictTit,nTamVal+7,.F.,) 	//"(Vencidos+Vencer)"

oSection1:Cell("VAL_ORIG"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_NOMI"):SetHeaderAlign("RIGHT")             
oSection1:Cell("VAL_CORR"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_VENC"):SetHeaderAlign("RIGHT")
oSection1:Cell("JUROS")   :SetHeaderAlign("RIGHT")  
oSection1:Cell("VAL_SOMA"):SetHeaderAlign("RIGHT") 

oSection1:SetLineBreak(.f.)		//Quebra de linha automatica

oSection2 := TRSection():New(oReport,STR0061,{"SM0"},aOrdem)

TRCell():New(oSection2,"FILIAL"		,,STR0065	,			,105) //"Total por Filial:"
TRCell():New(oSection2,"VALORORIG"	,,STR0048				,cPictTit	,nTamVal+3)//"Valor Original"
TRCell():New(oSection2,"VALORNOMI"	,,STR0049+CRLF+STR0050	,cPictTit	,nTamVal+3)//"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection2,"VALORCORR"	,,STR0049+CRLF+STR0051	,cPictTit	,nTamVal+3)//"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection2,"VALORVENC"	,,STR0052+CRLF+STR0050	,cPictTit	,nTamVal+3)//"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection2,"JUROS"		,,STR0055+CRLF+STR0056	,cPictTit	,nTamVal+5)//"Vlr.juros ou" + "permanencia"
TRCell():New(oSection2,"VALORSOMA"	,,STR0060				,cPictTit	,nTamVal+20)//"(Vencidos+Vencer)"


oSection2:Cell("VALORORIG"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALORNOMI"):SetHeaderAlign("RIGHT")             
oSection2:Cell("VALORCORR"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALORVENC"):SetHeaderAlign("RIGHT")
oSection2:Cell("JUROS")   :SetHeaderAlign("RIGHT")  
oSection2:Cell("VALORSOMA"):SetHeaderAlign("RIGHT")

oSection2:SetLineBreak(.F.)

Return oReport                                                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Daniel Batori          ³ Data ³08.08.06	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)

Local oSection1	:=	oReport:Section(1) 
Local oSection2	:=	oReport:Section(2)
Local nOrdem 	:= oSection1:GetOrder()
Local oBreak
Local oBreak2

Local aDados[17]
//Local cString :="SE2"
Local nRegEmp := SM0->(RecNo())
Local nRegSM0 := SM0->(Recno())
Local nAtuSM0 := SM0->(Recno())
Local dOldDtBase := dDataBase
Local dOldData := dDataBase
Local nJuros  :=0

Local nQualIndice := 0
Local lContinua := .T.
Local nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
Local nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
LOcal nTotFil0:=0, nTotFil1:=0, nTotFil2:=0, nTotFil3:=0,nTotFil4:=0, nTotFilTit:=0, nTotFilJ:=0
Local nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
Local cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
Local dDataReaj
Local dDataAnt := dDataBase , lQuebra
Local nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
Local dDtContab
Local cIndexSe2
Local cChaveSe2
Local nIndexSE2
Local cFilDe,cFilAte
Local nTotsRec := SE2->(RecCount())
//Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(mv_par15)
Local lFr150Flt := EXISTBLOCK("FR150FLT")
Local cFr150Flt := iif(lFr150Flt,ExecBlock("FR150FLT",.F.,.F.),"")
Local cMoeda := LTrim(Str(mv_par15))
Local cFilterUser
Local cFilUserSA2 := oSection1:GetADVPLExp("SA2")

Local cNomFor	:= ""
Local cNomNat	:= ""
Local cNomFil	:= ""
Local cNumBco	:= 0
Local nTotVenc	:= 0
Local nTotMes	:= 0
Local nTotGeral := 0
Local nTotTitMes:= 0
Local nTotFil	:= 0
Local dDtVenc
Local aFiliais	:= {}
Local lTemCont := .F.
//Local cNomFilAnt := ""
Local cFilialSE2	:= ""
Local nInc := 0    
Local aSM0 := {}
Local cPictTit := ""
Local nGerTot := 0
Local nFilTot := 0
Local nAuxTotFil := 0
Local nRecnoSE2 := 0

Local aTotFil :={}
local lQryEmp := .F.
Local nI := 0
Local dUltBaixa	:= STOD("")
//Local nCont	:= 0
//Local nTamFil	:= FWSizeFilial()
Local lExistFJU := FJU->(ColumnPos("FJU_RECPAI")) > 0 .and. FindFunction("FinGrvEx")
Local cCampos := ""
Local cQueryP := ""
#IFDEF TOP
	Local aStru := SE2->(dbStruct())
#ENDIF

/*
GESTAO - inicio */
Local nFilAtu		:= 0
Local nLenSelFil	:= 0
Local nTamUnNeg		:= 0
Local nTamEmp		:= 0
Local nTotEmp		:= 0
Local nTotEmpJ		:= 0
Local nTotEmp0		:= 0
Local nTotEmp1		:= 0
Local nTotEmp2		:= 0
Local nTotEmp3		:= 0
Local nTotEmp4		:= 0
Local nTotTitEmp	:= 0
Local cNomEmp		:= ""
Local cTmpFil		:= ""
//Local cQryFilSE1	:= ""
Local cQryFilSE5	:= ""
Local lTotEmp		:= .F.
Local aTmpFil		:= {}
Local oBrkFil		:= Nil
Local oBrkEmp		:= Nil
Local oBrkNat		:= Nil
Local nBx			:= 0
/* GESTAO - fim
*/

Private dBaixa := dDataBase
Private cTitulo  := ""

cPictTit := PesqPict("SE2","E2_VALOR")
If cPaisLoc == "CHI"
	cPictTit := SubStr(cPictTit,1,At(".",cPictTit)-1)
EndIf   

/*
GESTAO - inicio */
If MV_PAR37 == 1
	If Empty(aSelFil)
		If  FindFunction("AdmSelecFil")
			AdmSelecFil("FIN150",37,.F.,@aSelFil,"SE2",.F.)
		Else
			aSelFil := AdmGetFil(.F.,.F.,"SE2")
			If Empty(aSelFil)
				Aadd(aSelFil,cFilAnt)
			Endif
		Endif
	Endif
Else
	Aadd(aSelFil,cFilAnt)
Endif
nLenSelFil := Len(aSelFil)
lTotFil := (nLenSelFil > 1)
nTamEmp := Len(FWSM0LayOut(,1))
nTamUnNeg := Len(FWSM0LayOut(,2))
lTotEmp := .F.
If nLenSelFil > 1
	nX := 1 
	While nX < nLenSelFil .And. !lTotEmp
		nX++
		lTotEmp := !(Substr(aSelFil[nX-1],1,nTamEmp) == Substr(aSelFil[nX],1,nTamEmp))
	Enddo
Else
	nTotTmp := .F.
Endif
cQryFilSE2 := GetRngFil( aSelFil, "SE2", .T., @cTmpFil)
Aadd(aTmpFil,cTmpFil)
cQryFilSE5 := GetRngFil( aSelFil, "SE5", .T., @cTmpFil)
Aadd(aTmpFil,cTmpFil)
/* GESTAO - fim
*/

//*******************************************************
// Solução para o problema no filtro de Serie minuscula *
//*******************************************************
//mv_par04 := LOWER(mv_par04)

oSection1:Cell("FORNECEDOR"	):SetBlock( { || aDados[FORNEC] 			})
oSection1:Cell("TITULO"		):SetBlock( { || aDados[TITUL] 				})
oSection1:Cell("E2_TIPO"	):SetBlock( { || aDados[TIPO] 					})
oSection1:Cell("E2_NATUREZ"	):SetBlock( { || MascNat(aDados[NATUREZA])})
oSection1:Cell("E2_EMISSAO"	):SetBlock( { || aDados[EMISSAO] 			})
oSection1:Cell("E2_VENCTO"	):SetBlock( { || aDados[VENCTO] 			})
oSection1:Cell("E2_VENCREA"	):SetBlock( { || aDados[VENCREA] 			})
oSection1:Cell("VAL_ORIG"	):SetBlock( { || aDados[VL_ORIG] 			})
oSection1:Cell("VAL_NOMI"	):SetBlock( { || aDados[VL_NOMINAL] 		})
oSection1:Cell("VAL_CORR"	):SetBlock( { || aDados[VL_CORRIG] 		})
oSection1:Cell("VAL_VENC"	):SetBlock( { || aDados[VL_VENCIDO] 		})
oSection1:Cell("E2_PORTADO"	):SetBlock( { || aDados[PORTADOR] 			})
oSection1:Cell("JUROS"		):SetBlock( { || aDados[VL_JUROS] 			})
oSection1:Cell("DIA_ATR"	):SetBlock( { || aDados[ATRASO] 				})
oSection1:Cell("E2_HIST"	):SetBlock( { || aDados[HISTORICO] 			})
oSection1:Cell("VAL_SOMA"	):SetBlock( { || aDados[VL_SOMA] 			})

oSection1:Cell("VAL_SOMA"):Disable()

TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define as quebras da seção, conforme a ordem escolhida.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 2	//Natureza
	oBreak := TRBreak():New(oSection1,{|| IIf(!MV_MULNATP,SE2->E2_NATUREZ,aDados[NATUREZA]) },{|| cNomNat })
	oBrkNat := oBreak
ElseIf nOrdem == 3	.Or. nOrdem == 6	//Vencimento e por Emissao
	oBreak  := TRBreak():New(oSection1,{|| IIf(nOrdem == 3,SE2->E2_VENCREA,SE2->E2_EMISSAO) },{|| STR0026 + DtoC(dDtVenc) })	//"S U B - T O T A L ----> "
	oBreak2 := TRBreak():New(oSection1,{|| IIf(nOrdem == 3,Month(SE2->E2_VENCREA),Month(SE2->E2_EMISSAO)) },{|| STR0030 + "("+ALLTRIM(STR(nTotTitMes))+" "+IIF(nTotTitMes > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")" })		//"T O T A L   D O  M E S ---> "
	If mv_par20 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, nTotGeral, nTotMes)},.F.,.F.)
	EndIf
ElseIf nOrdem == 4	//Banco
	oBreak := TRBreak():New(oSection1,{|| SE2->E2_PORTADO },{|| STR0026 + cNumBco })	//"S U B - T O T A L ----> "
ElseIf nOrdem == 5	//Fornecedor
	oBreak := TRBreak():New(oSection1,{|| SE2->(E2_FORNECE+E2_LOJA) },{|| cNomFor })
ElseIf nOrdem == 7	//Codigo Fornecedor
	oBreak := TRBreak():New(oSection1,{|| SE2->E2_FORNECE },{|| cNomFor })	
EndIf                                                                       


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimir TOTAL por filial somente quando ³
//³ houver mais do que uma filial.	         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SM0->(Reccount()) > 1 .And. nLenSelFil > 1
	If nOrdem  == 3 .Or. nOrdem == 6
		oSection2:Cell("FILIAL"	)	:SetBlock( { || aTotFil[ni,1] + aTotFil[ni,9]})
		oSection2:Cell("VALORORIG")	:SetBlock( { || aTotFil[ni,2]})
		oSection2:Cell("VALORNOMI")	:SetBlock( { || aTotFil[ni,3]})
		oSection2:Cell("VALORCORR")	:SetBlock( { || aTotFil[ni,4]})
		oSection2:Cell("VALORVENC")	:SetBlock( { || aTotFil[ni,5]})
		oSection2:Cell("JUROS")		:SetBlock( { || aTotFil[ni,8]})
		oSection2:Cell("VALORSOMA")	:SetBlock( { || aTotFil[ni,4] + aTotFil[ni,5]})

		TRPosition():New(oSection2,"SM0",1,{|| xFilial("SM0")+SM0->M0_CODIGO+	SM0->M0_CODFIL })
	Else
		oBreak2 := TRBreak():New(oSection1,{|| SE2->E2_FILIAL },{|| STR0032+" "+cNomFil })	//"T O T A L   F I L I A L ----> " 
		If mv_par20 == 1	//1- Analitico  2-Sintetico
			TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
			TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
			//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
			//embora seja estranho mas neste caso foi necessario inicializar a variavel nFilTot:=0 no break 
			//por isso salvei o conteudo na variavel nAuxTotFil antes de inicializar e depois imprimo nAuxTotFil
			TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, ( nAuxTotFil:=nFilTot,nFilTot:=0,nAuxTotFil )/*nTotGeral*/, nTotFil)},.F.,.F.)
		EndIf
	EndIf 
EndIf

/*
GESTAO - inicio */
/* quebra por empresa */
If lTotEmp .And. MV_MULNATP .And. nOrdem == 2 
	oBrkEmp := TRBreak():New(oSection1,{|| Substr(SE2->E2_FILIAL,1,nTamEmp)},{|| STR0064 + " " + cNomEmp })		//"T O T A L  E M P R E S A -->" 
	// "Salta pagina por cliente?" igual a "Sim" e a ordem eh por cliente ou codigo do cliente
/*	If mv_par35 == 1 .And. (nOrdem == 1 .Or. nOrdem == 8)
		oBrkEmp:OnPrintTotal( { || oReport:EndPage() } )	// Finaliza pagina atual
	Else
		oBrkEmp:OnPrintTotal( { || oReport:SkipLine()} )
	EndIf*/
	If mv_par20 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBrkEmp,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBrkEmp,,PesqPict("SE2","E2_VALOR"),{|lSection,lReport| If(lReport, nTotGeral, nTotEmp)},.F.,.F.)
	EndIf
Endif
/* GESTAO - fim 
*/

If mv_par20 == 1	//1- Analitico  2-Sintetico
	//Altero o texto do Total Geral
	oReport:SetTotalText({|| STR0027 + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,STR0028,STR0029)+")" })
	TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak,,,,.F.,.T.)
	//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
	//portanto foi criado a variavel nGerTot que eh o acumulador geral da coluna
	TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport, nGerTot/*nTotGeral*/, nTotVenc)},.F.,.T.)
EndIf

#IFDEF TOP
	IF TcSrvType() == "AS/400" .and. Select("__SE2") == 0
		ChkFile("SE2",.f.,"__SE2")
	Endif
#ENDIF

dbSelectArea ( "SE2" )
Set Softseek On

If mv_par37 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
Endif

//Acerta a database de acordo com o parametro
If mv_par21 == 1    // Considera Data Base
	dDataBase := mv_par33
Endif	

dbSelectArea("SM0")

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

//Caso nao preencha o mv_par15 um erro ocorre ao procurar o parametro do sistema MV_MOEDA0.
If Val(cMoeda) == 0
	cMoeda := "1"
Endif

cTitulo := oReport:title()
cTitAux := cTitulo
            
// Cria vetor com os codigos das filiais da empresa corrente                     
aFiliais := FinRetFil()

oSection1:Init()      

aSM0	:= AdmAbreSM0()

/*
GESTAO - inicio */
If nLenSelFil == 0
	// Cria vetor com os codigos das filiais da empresa corrente
	aFiliais := FinRetFil()
	lContinua := SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
Else
	aFiliais := Aclone(aSelFil)
	cFilDe := aSelFil[1]
	cFilAte := aSelFil[nLenSelFil]
	nFilAtu := 1
	lContinua := nFilAtu <= nLenSelFil
	aSM0 := FWLoadSM0()
Endif
/* GESTAO - fim 
*/

nInc := 1

While nInc <= Len( aSM0 )
	
	If !Empty(cFilAte) .AND. aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte) .and. lContinua
		
		//UTILIZADO PARA VALIDAR AS FILIAIS SELECIONADAS PELO USUARIO.
		If Ascan(aSelFil,aSM0[nInc][2]) == 0
			nInc++
			Loop						
		Endif
		
		cTitulo += " " + STR0035 + GetMv("MV_MOEDA"+cMoeda)  //"Posicao dos Titulos a Pagar" + " em "
	
		dbSelectArea("SE2")
		/*
		GESTAO - inicio */
		If nLenSelFil > 0
			nPosFil := aScan( aSM0 ,{ | sm0 | sm0[SM0_GRPEMP] + sm0[SM0_CODFIL] == aSM0[nInc][1] + aSelFil[nFilAtu] } )
			If nPosFil > 0
				SM0->( DbGoTo( aSM0[nPosFil,SM0_RECNO] ) )
			Else
				SM0->( MsSeek( cEmpAnt + aSelFil[nFilAtu] ) )
			EndIf
		EndIf
		cFilAnt := aSM0[nInc][2]
		/* GESTAO - fim
		*/ 
		
		IF cFilialSE2 == xFilial("SE2")
			Loop
		ELSE
			cFilialSE2 := xFilial("SE2")
		ENDIF
			
		#IFDEF TOP
				cFilterUser := oSection1:GetSqlExp("SE2")
				if TcSrvType() != "AS/400"
					cCampos := ""
					aEval(SE2->(DbStruct()),{|e| If(e[2]<> "M", cCampos += ",SE2."+AllTrim(e[1]),Nil)})
					cCampos += ",SE2.R_E_C_N_O_, SE2.R_E_C_D_E_L_, SE2.D_E_L_E_T_ " 
					cQuery := "SELECT " + SubStr(cCampos,2)
					cQuery += "  FROM "+	RetSqlName("SE2")+ " SE2"
					/*
					GESTAO - inicio 
					*/
						cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
					/* GESTAO - fim
					*/
					cQuery += "   AND D_E_L_E_T_ = ' ' " 
					If !empty(cFilterUser)
					  	cQueryP += " AND ( "+cFilterUser + " ) "
					Endif
				endif
		#ENDIF
	
		IF nOrdem == 1
			SE2->(dbSetOrder(1))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
			#ENDIF
			cCond1 := "SE2->E2_PREFIXO <= mv_par04"
			cCond2 := "SE2->E2_PREFIXO"
			cTitulo += OemToAnsi(STR0016)  //" - Por Numero"
			nQualIndice := 1
		Elseif nOrdem == 2
			SE2->(dbSetOrder(2))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par05,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par05,.T.)
			#ENDIF
			cCond1 := "SE2->E2_NATUREZ <= mv_par06"
			cCond2 := "SE2->E2_NATUREZ"
			cTitulo += STR0017  //" - Por Natureza"
			nQualIndice := 2
		Elseif nOrdem == 3
			SE2->(dbSetOrder(3))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
			#ENDIF
			cCond1 := "SE2->E2_VENCREA <= mv_par08"
			cCond2 := "SE2->E2_VENCREA"
			cTitulo += STR0018  //" - Por Vencimento"
			nQualIndice := 3
		Elseif nOrdem == 4
			SE2->(dbSetOrder(4))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par09,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par09,.T.)
			#ENDIF
			cCond1 := "SE2->E2_PORTADO <= mv_par10"
			cCond2 := "SE2->E2_PORTADO"
			cTitulo += OemToAnsi(STR0031)  //" - Por Banco"
			nQualIndice := 4
		Elseif nOrdem == 6
			SE2->(dbSetOrder(5))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
			#ENDIF
			cCond1 := "SE2->E2_EMISSAO <= mv_par14"
			cCond2 := "SE2->E2_EMISSAO"
			cTitulo += STR0019 //" - Por Emissao"
			nQualIndice := 5
		Elseif nOrdem == 7
			SE2->(dbSetOrder(6))
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					dbSeek(xFilial("SE2")+mv_par11,.T.)
				else
					cOrder := SqlOrder(indexkey())
				endif
			#ELSE
				dbSeek(xFilial("SE2")+mv_par11,.T.)
			#ENDIF			
			cCond1 := "SE2->E2_FORNECE <= mv_par12"
			cCond2 := "SE2->E2_FORNECE"
			cTitulo += STR0020 //" - Por Cod.Fornecedor"
			nQualIndice := 6
		Else
			cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
			#IFDEF TOP
				if TcSrvType() == "AS/400"
					cIndexSe2 := CriaTrab(nil,.f.)
					IndRegua("SE2",cIndexSe2,cChaveSe2,,Tfr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
					nIndexSE2 := RetIndex("SE2")
					dbSetOrder(nIndexSe2+1)
					dbSeek(xFilial("SE2"))
				else
					cOrder := SqlOrder(cChaveSe2)
				endif
			#ELSE
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Tfr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetIndex(cIndexSe2+OrdBagExt())
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			#ENDIF
			cCond1 := "SE2->E2_FORNECE <= mv_par12"
			cCond2 := "SE2->E2_FORNECE+SE2->E2_LOJA"
			cTitulo += STR0022 //" - Por Fornecedor"
			nQualIndice := IndexOrd()
		EndIF
	
		If mv_par20 == 1	//1- Analitico  2-Sintetico	
			cTitulo += STR0023  //" - Analitico"
		Else
			cTitulo += STR0024  // " - Sintetico"
		EndIf
	
		oReport:SetTitle(cTitulo)
		cTitulo := cTitAux
		
		dbSelectArea("SE2")
	
		Set Softseek Off
	
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				cQueryP += " AND SE2.E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
				cQueryP += " AND SE2.E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
				cQueryP += " AND (SE2.E2_MULTNAT = '1' OR (SE2.E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
				cQueryP += " AND SE2.E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
				cQueryP += " AND SE2.E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
				cQueryP += " AND SE2.E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
				cQueryP += " AND SE2.E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"
				cQueryP += " AND SE2.E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'"
	
				//Considerar titulos cuja emissao seja maior que a database do sistema
				If mv_par36 == 2
					cQueryP += " AND SE2.E2_EMISSAO <= '" + DTOS(dDataBase) +"'"
				Endif
		
				If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
					cQueryP += " AND SE2.E2_TIPO IN "+FormatIn(mv_par30,";") 
				ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
					cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(mv_par31,";")
				EndIf
				If mv_par32 == 1
					cQueryP += " AND SE2.E2_FLUXO <> 'N'"
				Endif
				
				cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
				
				If mv_par16 == 2
					cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")			
				Endif
				
				If mv_par27 == 2
					cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")			 
					cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")			
				Endif		
				cQuery += cQueryP
				If lExistFJU
					If MV_PAR38 == 1
				    	if TcSrvType() != "AS/400"
							cQuery += " AND SE2.R_E_C_N_O_ NOT IN (SELECT PAI.FJU_RECPAI FROM "+ RetSqlName("FJU")+" PAI " 
							cQuery += " WHERE PAI.D_E_L_E_T_ = ' ' AND "
							cQuery += " PAI.FJU_CART = 'P' AND "
							cQuery += " PAI.FJU_DTEXCL >= '" + DTOS(dDataBase) + "' "
							cQuery += " AND PAI.FJU_EMIS1 <= '" + DTOS(dDataBase) + "') "			    		
					       cQuery += "UNION "
							
							cQuery += "SELECT " + SubStr(cCampos,2)
							cQuery += " FROM "+ RetSqlName("SE2")+" SE2,"+ RetSqlName("FJU") +" FJU"
							cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
							cQuery += " AND FJU.FJU_FILIAL	 = '" + xFilial("FJU") + "'"
							cQuery += " AND SE2.E2_PREFIXO 	= FJU.FJU_PREFIX "
							cQuery += " AND SE2.E2_NUM 		= FJU.FJU_NUM "
							cQuery += " AND SE2.E2_PARCELA 	= FJU.FJU_PARCEL "
							cQuery += " AND SE2.E2_TIPO 	= FJU.FJU_TIPO "
							cQuery += " AND SE2.E2_FORNECE	= FJU.FJU_CLIFOR "
							cQuery += " AND SE2.E2_LOJA 	= FJU.FJU_LOJA "
							cQuery += " AND FJU.FJU_EMIS   <= '" + DTOS(dDataBase) +"'"
							cQuery += " AND FJU.FJU_DTEXCL >= '" + DTOS(dDataBase) +"'"
							cQuery += " AND FJU.FJU_CART = 'P' "
							cQuery += " AND SE2.R_E_C_N_O_ = FJU.FJU_RECORI "
							cQuery += " AND FJU.FJU_RECORI IN ( SELECT MAX(FJU_RECORI) "
	     
							cQuery +=   "FROM "+ RetSqlName("FJU")+" LASTFJU "
							cQuery +=   "WHERE LASTFJU.FJU_FILIAL = FJU.FJU_FILIAL "
							cQuery +=   "AND LASTFJU.FJU_PREFIX = FJU.FJU_PREFIX "
							cQuery +=   "AND LASTFJU.FJU_NUM = FJU.FJU_NUM "
							cQuery +=   "AND LASTFJU.FJU_PARCEL = FJU.FJU_PARCEL "
							cQuery +=   "AND LASTFJU.FJU_TIPO = FJU.FJU_TIPO "
							cQuery +=   "AND LASTFJU.FJU_CLIFOR = FJU.FJU_CLIFOR "
							cQuery +=   "AND LASTFJU.FJU_LOJA = FJU.FJU_LOJA "	
					    	cQuery +=   "AND FJU.FJU_DTEXCL = LASTFJU.FJU_DTEXCL "
							    
							cQuery +=   "GROUP BY FJU_FILIAL "
							cQuery +=   ",FJU_PREFIX "
							cQuery +=   ",FJU_NUM "
							cQuery +=   ",FJU_PARCEL "
							cQuery +=   ",FJU_CLIFOR "
							cQuery +=   ",FJU_LOJA ) "
	      
							cQuery += " AND SE2.D_E_L_E_T_ = '*' " 
							cQuery += " AND FJU.D_E_L_E_T_ = ' ' " 
							
							cQuery += " AND " 
							cQuery += " (SELECT COUNT(*) " 
							cQuery += " FROM "+ RetSqlName("SE2")+" NOTDEL " 
							cQuery += " WHERE NOTDEL.E2_FILIAL = FJU.FJU_FILIAL "         
							cQuery += " AND NOTDEL.E2_PREFIXO = FJU.FJU_PREFIX     "      
							cQuery += " AND NOTDEL.E2_NUM = FJU.FJU_NUM            "
							cQuery += " AND NOTDEL.E2_PARCELA = FJU.FJU_PARCEL      "        
							cQuery += " AND NOTDEL.E2_TIPO = FJU.FJU_TIPO "        
							cQuery += " AND NOTDEL.E2_FORNECE = FJU.FJU_CLIFOR       "     
							cQuery += " AND NOTDEL.E2_LOJA = FJU.FJU_LOJA  	"
							cQuery += " AND FJU.FJU_RECPAI = 0 "
							cQuery += " AND NOTDEL.E2_EMIS1   <= '" + DTOS(dDataBase) +"'"
							cQuery += " AND NOTDEL.D_E_L_E_T_ = '') = 0 " 
							 
							cQuery += " AND FJU.FJU_RECORI NOT IN (SELECT PAI.FJU_RECPAI FROM "+ RetSqlName("FJU")+" PAI " 
							cQuery += " WHERE PAI.D_E_L_E_T_ = ' ' AND "
							cQuery += " PAI.FJU_CART = 'P' AND "
							cQuery += " PAI.FJU_DTEXCL >= '" + DTOS(dDataBase) + "' "
							cQuery += " AND PAI.FJU_EMIS1 <= '" + DTOS(dDataBase) + "') "			    		
							 
							cQuery += cQueryP
						Endif	
					Endif	
				Endif									
	
				cQuery += " ORDER BY "+ cOrder

				Memowrite("FINT150_AGGING_CTA_PAGAR.SQL",cQuery)	
				//_cQuery := "EXEC SP_REL_FINT150_AGGING '" + cQuery + "'"
				//TCQUERY _cQuery NEW ALIAS (_cAlias := GetNextAlias())
				
				cQuery := ChangeQuery(cQuery)	
				dbSelectArea("SE2")
				dbCloseArea()
				dbSelectArea("SA2")
	
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)
	
				For ni := 1 to Len(aStru)
					If aStru[ni,2] != 'C'
						TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
					Endif
				Next
			endif
		#ELSE
			cFilterUser := oSection1:GetADVPLExp("SE2")
			
			If !Empty(cFilterUser)
				oSection1:SetFilter(cFilterUser)
			Endif	
		#ENDIF
		
		oReport:SetMeter(nTotsRec)
	
		If MV_MULNATP .And. nOrdem == 2
		/*
		GESTAO - inicio */
		If nLenSelFil == 0
			Finr155(cFr150Flt, .F., @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ, oReport, aDados, @cNomNat, @nTotVenc, @nTotGeral)
		Else
			cTitBkp := cTitulo
			Finr155(cFr150Flt, .F., @nTotFil0, @nTotFil1, @nTotFil2, @nTotFil3, @nTotFilTit, @nTotFilJ, oReport, aDados, @cNomNat, @nTotVenc, @nTotGeral)
			nTot0 += nTotFil0
			nTot1 += nTotFil1
			nTot2 += nTotFil2
			nTot3 += nTotFil3
			nTot4 += nTotFil4
			nTotJ += nTotFilJ
			nTotTit += nTotFilTit
			cNomFil := cFilAnt + " - " + AllTrim(SM0->M0_FILIAL)
			cNomEmp := Substr(cFilAnt,1,nTamEmp) + " - " + AllTrim(SM0->M0_NOMECOM)
			cTitulo := cTitBkp
		Endif
		/* GESTAO - fim
		*/
			#IFDEF TOP
				if TcSrvType() != "AS/400"
					dbSelectArea("SE2")
					dbCloseArea()
					ChKFile("SE2")
					dbSetOrder(1)
				endif
			#ENDIF
			/*
			GESTAO - inicio */
			If nLenSelFil == 0
				dbSelectArea("SM0")
				dbSkip()
				lContinua := SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
			Else
				nFilAtu++
				lContinua := (nFilAtu <= nLenSelFil)
				If lContinua
					If oBrkNat:Execute()
						oBrkNat:PrintTotal()
					Endif
					If nTotFil0 <> 0
						oBrkFil := oBreak
						If oBrkFil:Execute()
							oBrkFil:PrintTotal()
						Endif
					Endif
					Store 0 To nTotFil0,nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFilTit,nTotFilJ
					If !(Substr(aSelFil[nFilAtu-1],1,nTamEmp) == Substr(aSelFil[nFilAtu],1,nTamEmp))
						If nTotEmp0 <> 0
							oBrkEmp:PrintTotal()
						Endif
						nTotEmp0 := 0
						nTotEmp1 := 0
						nTotEmp2 := 0
						nTotEmp3 := 0
						nTotEmp4 := 0
						nTotEmpJ := 0
						nTotTitEmp := 0
					Endif
				Endif
			Endif
			/* GESTAO - fim
			*/
			If Empty(xFilial("SE2")) .and. mv_par22 = 2
				Exit
			Endif
			Loop
		Endif  
		
		lQryEmp := Eof()
		//CT conout(cCond1)
		//CT CONOUT(mv_par04)
		//CT CONOUT(lContinua)
		While &cCond1 .and. !Eof() .and. lContinua .and. SE2->E2_FILIAL == xFilial("SE2")
		
			oReport:IncMeter()
	
			dbSelectArea("SE2")
	
			Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
	
			If nOrdem == 3 .And. Str(Month(SE2->E2_VENCREA)) <> Str(Month(dDataAnt))
				nMesTTit := 0
			Elseif nOrdem == 6 .And. Str(Month(SE2->E2_EMISSAO)) <> Str(Month(dDataAnt))
				nMesTTit := 0
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega data do registro para permitir ³
			//³ posterior analise de quebra por mes.   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
			cCarAnt := &cCond2
		//CT conout(cCond2)
		
	        
			lTemCont := .F.
//			Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
			While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. SE2->E2_FILIAL == xFilial("SE2")
				
				oReport:IncMeter()
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtro de usuário pela tabela SA2.					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SA2")
				MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				If !Empty(cFilUserSA2).And.!SA2->(&cFilUserSA2)
					SE2->(dbSkip())
					Loop
				Endif
				//CT conout(PROCLINE())
				dbSelectArea("SE2")
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario no ponto de entrada.             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFr150flt
					If &cFr150flt
						DbSkip()
						Loop
					Endif
				Endif					
				//CT conout(PROCLINE())
				
				#IFNDEF TOP			
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se trata-se de abatimento ou provisorio, ou ³
				//³ Somente titulos emitidos ate a data base				   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF SE2->E2_TIPO $ MVABATIM .Or. (SE2 -> E2_EMISSAO > dDataBase .and. mv_par36 == 2)
					dbSkip()
					Loop
				EndIF
				//CT conout(PROCLINE())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ser  impresso titulos provis¢rios		   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF E2_TIPO $ MVPROVIS .and. mv_par16 == 2
					dbSkip()
					Loop
				EndIF
				//CT conout(PROCLINE())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ser  impresso titulos de Adiantamento	 	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par27 == 2
					dbSkip()
					Loop
				EndIF
				//CT conout(PROCLINE())
	                                   
	            #ENDIF
	            
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se deve imprimir outras moedas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par29 == 2 // nao imprime
					if SE2->E2_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
						dbSkip()
						Loop
					endif	
				Endif  
//CT conout("Linha: " + Alltrim(str(PROCLINE())) )
	
				// dDtContab para casos em que o campo E2_EMIS1 esteja vazio
				// compatibilizando com a vers„o 2.04 que n„o gerava para titulos
				// de ISS e FunRural
	
				dDtContab := Iif(Empty(SE2->E2_EMIS1),SE2->E2_EMISSAO,SE2->E2_EMIS1)
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se esta dentro dos parametros ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
						E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
						E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
						E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
						E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
						E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
						E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
						(E2_EMISSAO > dDataBase .and. mv_par36 == 2) .OR. dDtContab  < mv_par18 .OR. ;
						E2_LOJA    < mv_par25  .OR. E2_LOJA    > mv_par26 .OR. ;
						dDtContab  > mv_par19  .Or. !&(Tfr150IndR())

//CT conout( "Data contabil: " + dtos(dDtContab) + " Emissao: " + dtos(E2_EMISSAO) + " Data base: " + dtos(dDataBase) )
//CT conout( "mv_par36: " + alltrim(str(mv_par36)) + " mv_par18: " + DTOS(mv_par18) + " mv_par19: " + DTOS(mv_par19) )


//CT conout("Linha: " + Alltrim(str(PROCLINE())) )
	
					dbSkip()
					Loop
				Endif  
				//CT conout(PROCLINE())
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se esta dentro do parametro compor pela data de digitação ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF mv_par34 == 2 .And. !Empty(E2_EMIS1) .And. !Empty(mv_par33)
					If E2_EMIS1 > mv_par33
						dbSkip()
						Loop
					Endif			
				Endif
				//CT conout(PROCLINE())
							
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ³
				//³ nÆo no relat¢rio quando se considera database (mv_par21 = 1) ³
				//³ ou caso nÆo se considere a database, se o titulo foi totalmen³
				//³ te baixado.																  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE2")
				IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par21 == 2 ,SE2->E2_SALDO == 0 ,SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase)						

					dbSkip()
					Loop
				EndIF
				//CT conout(PROCLINE())
	            
				 // Tratamento da correcao monetaria para a Argentina
				If  cPaisLoc=="ARG" .And. mv_par15 <> 1  .And.  SE2->E2_CONVERT=='N'
					dbSkip()
					Loop
				Endif
				//CT conout(PROCLINE())
	
				
				dbSelectArea("SA2")
				MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
				dbSelectArea("SE2")
	
				// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
				If SE2->E2_VENCREA < dDataBase
					If mv_par17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
						dDataReaj := SE2->E2_VENCREA
					Else
						dDataReaj := dDataBase
					EndIf	
				Else
					dDataReaj := dDataBase
				EndIf       
				//CT conout(dDataReaj)
	
				If mv_par21 == 1
					nSaldo := U_TxSaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA,,If(mv_par35==1,SE2->E2_TXMOEDA,Nil),IIF(mv_par34 == 2,3,1)) // 1 = DT BAIXA    3 = DT DIGIT
					//Verifica se existem compensações em outras filiais para descontar do saldo, pois a SaldoTit() somente
					//verifica as movimentações da filial corrente. Nao deve processar quando existe somente uma filial.
//CT conout("SALDO: " + Alltrim(str(nSaldo)) + " Linha: " + alltrim(str(procline())) )

					If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SE5"))
						If SA2->A2_INTER!="S"
							nSaldo -= FRVlCompFil("P",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(mv_par34 == 2,3,1),,,,mv_par15,SE2->E2_MOEDA,If(mv_par35==1,SE2->E2_TXMOEDA,Nil),dDataReaj,.T.)
						Else
							// A chamada da função U_TFFRVlCompFil foi alterada, pois estava sendo passado mais parametros do que a função está preparada para receber 
							//nSaldo -= U_TFFRVlCompFil("P"    ,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(mv_par34 == 2,3,1),        ,       ,      ,mv_par15,SE2->E2_MOEDA,If(mv_par35==1,SE2->E2_TXMOEDA,Nil),dDataReaj,.T.)
							nSaldo -= U_TFFRVlCompFil("P"    ,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(mv_par34 == 2,3,1)  ,        ,       ,      )
									  //TFFRVlCompFil(cRecPag,cPrefixo       ,cNumero    ,cParcela       ,cTipo       ,cCliFor        ,cLoja       ,nTipoData             ,aFiliais,cFilQry,lAS400)
						EndIf
					EndIf
//CT conout("SALDO: " + Alltrim(str(nSaldo)) + " Linha: " + alltrim(str(procline())) )

					// Subtrai decrescimo para recompor o saldo na data escolhida.
					If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
						nSAldo -= SE2->E2_DECRESC
					Endif	
//CT conout("SALDO: " + Alltrim(str(nSaldo)) + " Linha: " + alltrim(str(procline())) )

					// Soma Acrescimo para recompor o saldo na data escolhida.
					If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
						nSAldo += SE2->E2_ACRESC
					Endif				
//CT conout("SALDO: " + Alltrim(str(nSaldo)) + " Linha: " + alltrim(str(procline())) )


				Else
					nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
//CT conout("SALDO: " + Alltrim(str(nSaldo)) + " Linha: " + alltrim(str(procline())) )
				Endif
//CT conout("SALDO: " + Alltrim(str(nSaldo)) + " Linha: " + alltrim(str(procline())) )

				If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
				   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
	
					//Quando considerar Titulos com emissao futura, eh necessario
					//colocar-se a database para o futuro de forma que a Somaabat()
					//considere os titulos de abatimento
					If mv_par36 == 1
						dOldData := dDataBase
						dDataBase := CTOD("31/12/40")
					Endif
	
					nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)
	
					If mv_par36 == 1
						dDataBase := dOldData
					Endif
				EndIf
//CT conout("SALDO: " + Alltrim(str(nSaldo)) + " Linha: " + alltrim(str(procline())) )
				nSaldo:=Round(NoRound(nSaldo,3),2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desconsidera caso saldo seja menor ou igual a zero   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nSaldo <= 0
					dbSkip()
					Loop
				Endif  
				//CT conout(PROCLINE())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Desconsidera os titulos de acordo com o parametro 
				//	considera filial e a tabela SE2 estiver compartilhada³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				If MV_PAR22 == 1 .and. Empty(xFilial("SE2"))
					If !(SE2->E2_FILORIG >= mv_par23 .and. SE2->E2_FILORIG <= mv_par24) 
						dbSkip()
						Loop
					Endif			
				Endif 
				//CT conout(PROCLINE())
	
				aDados[FORNEC] := SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+If(mv_par28 == 1, SA2->A2_NREDUZ, SA2->A2_NOME)
				aDados[TITUL]		:= SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
				aDados[TIPO]		:= SE2->E2_TIPO
				aDados[NATUREZA]	:= SE2->E2_NATUREZ
				aDados[EMISSAO]	:= SE2->E2_EMISSAO
				aDados[VENCTO]		:= SE2->E2_VENCTO
				aDados[VENCREA]	:= SE2->E2_VENCREA
				aDados[VL_ORIG]	:= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
	
				#IFDEF TOP
					If TcSrvType() == "AS/400"
						dbSetOrder( nQualIndice )
					Endif
				#ELSE
					dbSetOrder( nQualIndice )
				#ENDIF
	
				If dDataBase > SE2->E2_VENCREA 		//vencidos
					aDados[VL_NOMINAL] := nSaldo * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
					nJuros := 0
					dBaixa := dDataBase
					
					// Cálculo dos Juros retroativo.
					dUltBaixa := SE2->E2_BAIXA
					If MV_PAR21 == 1 // se compoem saldo retroativo verifico se houve baixas
						If !Empty(dUltBaixa) .And. dDataBase < dUltBaixa
							dUltBaixa := FR150DBX() // Ultima baixa até DataBase
						EndIf
					EndIf
					
					dbSelectArea("SE2")
					nJuros := fa080Juros(mv_par15,nSaldo,"SE2",dUltBaixa)
			
					dbSelectArea("SE2")
					aDados[VL_CORRIG] := (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)
					If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
						nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit1 -= nSaldo
						nTit2 -= nSaldo+nJuros
						nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit1 -= nSaldo
						nMesTit2 -= nSaldo+nJuros
					Else
						nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit1 += nSaldo
						nTit2 += nSaldo+nJuros
						nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit1 += nSaldo
						nMesTit2 += nSaldo+nJuros
					Endif
					nTotJur += (nJuros)
					nMesTitJ += (nJuros)
				Else				  //a vencer
					aDados[VL_VENCIDO] := nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
					If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
						nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit3 -= nSaldo
						nTit4 -= nSaldo
						nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit3 -= nSaldo
						nMesTit4 -= nSaldo
					Else
						nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nTit3 += nSaldo
						nTit4 += nSaldo
						nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
						nMesTit3 += nSaldo
						nMesTit4 += nSaldo
					Endif
				Endif
	
				ADados[PORTADOR] := SE2->E2_PORTADO
	
				If nJuros > 0
					aDados[VL_JUROS] := nJuros
					nJuros := 0
				Endif
	
				IF dDataBase > E2_VENCREA
					nAtraso:=dDataBase-E2_VENCTO
					IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
						IF Dow(dBaixa) == 2 .and. nAtraso <= 2
							nAtraso:=0
						EndIF
					EndIF
					nAtraso := If(nAtraso<0,0,nAtraso)
					IF nAtraso>0
						aDados[ATRASO] := nAtraso
					EndIF
				EndIF
				If mv_par20 == 1	//1- Analitico  2-Sintetico
					aDados[HISTORICO] := SUBSTR(SE2->E2_HIST,1,25)+If(E2_TIPO $ MVPROVIS,"*"," ")
					#IFDEF TOP					
						nRecnoSE2 := SE2->(R_E_C_N_O_)
					#ELSE
						nRecnoSE2 :=  SE2->(RECNO())
					#ENDIF
					DbChangeAlias("SE2","SE2QRY")
					DbChangeAlias("__SE2","SE2")
					SE2->(DBGoto(nRecnoSE2))
					oSection1:PrintLine()
					DbChangeAlias("SE2","__SE2")
					DbChangeAlias("SE2QRY","SE2")
					aFill(aDados,nil)
				EndIf
				cNomFil 	:= cFilAnt + " - " + AllTrim(aSM0[nInc][7])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega data do registro para permitir ³
				//³ posterior analise de quebra por mes.	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)
	
				If nOrdem == 5		//Forncedor
					cNomFor := If(mv_par28 == 1,AllTrim(SA2->A2_NREDUZ),AllTrim(SA2->A2_NOME))+" "+Substr(SA2->A2_TEL,1,15)
	            ElseIf nOrdem == 7	//Codigo Fornecedor
					cNomFor :=	SA2->A2_COD+" "+SA2->A2_LOJA+" "+AllTrim(SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
				EndIf
				
				If nOrdem == 2		//Natureza
					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
					cNomNat	:= MascNat(SED->ED_CODIGO)+" "+SED->ED_DESCRIC
				EndIf
				
				cNumBco	 := SE2->E2_PORTADO
				dDtVenc  := IIf(nOrdem == 3,SE2->E2_VENCREA,SE2->E2_EMISSAO)
				nTotVenc := nTit2+nTit3
				nTotMes	 := nMesTit2+nMesTit3
				//CT conout(PROCLINE())
	
				SE2->(dbSkip())
	
				nTotTit ++
				nMesTTit ++
				nFiltit++
				nTit5 ++
				nTotTitEmp++		/* GESTAO */				
			EndDo
	
			If nTit5 > 0 .and. nOrdem != 1 .And. mv_par20 == 2	//1- Analitico  2-Sintetico	
				SubTF150R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,oReport,oSection1)
			EndIF
					
		   	nTotGeral  := nTotMes 
			nTotTitMes := nMesTTit
			nGerTot  += nTit2+nTit3
			nFilTot  += nTit2+nTit3
	
			If mv_par20 == 2	//1- Analitico  2-Sintetico	
				lQuebra := .F.
				If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
					lQuebra := .T.
				Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
					lQuebra := .T.
				Endif
				If lQuebra .And. nMesTTit # 0
					oReport:SkipLine()
					IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)
					oReport:SkipLine()
					nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
				Endif
			EndIf
					
			dbSelectArea("SE2")
	
			nTot0 += nTit0
			nTot1 += nTit1
			nTot2 += nTit2
			nTot3 += nTit3
			nTot4 += nTit4
			nTotJ += nTotJur
			
			/*
			GESTAO - inicio */
			nTotEmp0 += nTit0
			nTotEmp1 += nTit1
			nTotEmp2 += nTit2
			nTotEmp3 += nTit3
			nTotEmp4 += nTit4
			nTotEmpJ += nTotJur
			/* GESTAO - fim
			 */	
	
			nFil0 += nTit0
			nFil1 += nTit1
			nFil2 += nTit2
			nFil3 += nTit3
			nFil4 += nTit4
			nFilJ += nTotJur
			Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
			
		Enddo					
	        
		nTotMes 	:= nTotVenc
		nTotFil 	:= nFil2 + nFil3
		nTotEmp 	+= nTotFil
		
		IF !lQryEmp .And. (nOrdem == 3 .OR. nOrdem == 6)
			aAdd(aTotFil,{aSM0[nInc][2],nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,aSM0[nInc][7]})
		EndIf

		If mv_par20 == 2	//1- Analitico  2-Sintetico	
			if mv_par22 == 1 .and. Len(aSM0) > 1 
				oReport:SkipLine()
				IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,oReport,oSection1,aSM0[nInc][7])
				Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
				oReport:SkipLine()			
			Endif	
		EndIf
		
		Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilJ,nTotJur

		dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
		If Empty(xFilial("SE2"))
			Exit
		Endif
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				dbSelectArea("SE2")
				dbCloseArea()
				ChKFile("SE2")
				dbSetOrder(1)
			endif
		#ENDIF
	
	EndIf
	nInc++
EndDo
	
SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL 


If mv_par20 == 2	//1- Analitico  2-Sintetico	
	If (nLenSelFil > 1) .Or. (mv_par22 == 1 .And. SM0->(Reccount()) > 1) 		
		oReport:ThinLine()  
		ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)
		oReport:SkipLine()
	Else
		ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)	
	EndIf
EndIf

oSection1:Finish()

IF nOrdem == 3 .OR. nOrdem == 6
	
	oSection2:Init()   
	For ni := 1 to Len(aTotFil)
		oSection2:printline()
	Next
	
	oSection2:Finish()
EndIf

#IFNDEF TOP
	dbSelectArea( "SE2" )
	dbClearFil()
	RetIndex( "SE2" )
	If !Empty(cIndexSE2)
		FErase (cIndexSE2+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
		/*
		GESTAO - inicio */
		If !Empty(aTmpFil)
			For nBx := 1 To Len(aTmpFil)
				CtbTmpErase(aTmpFil[nBx])
			Next
		Endif
		/* GESTAO - fim
		*/
	else
		dbSelectArea( "SE2" )
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura empresa / filial original    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SM0->(dbGoto(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If mv_par21 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTF150R  ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR SUBTOTAL DO RELATORIO 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTF150R()  															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SubTF150R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,oReport,oSection1)

Local cQuebra := ""

If nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 6
	cQuebra := STR0026 + DtoC(cCarAnt) //"S U B - T O T A L ----> "
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	cQuebra := cCarAnt +" "+SED->ED_DESCRIC
ElseIf nOrdem == 4
	cQuebra := STR0026 + cCarAnt //"S U B - T O T A L ----> "
Elseif nOrdem == 5
	cQuebra := If(mv_par28 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	cQuebra := SA2->A2_COD+" "+SA2->A2_LOJA+" "+SA2->A2_NOME+" "+Substr(SA2->A2_TEL,1,15)
Endif

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| cQuebra })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTit1   })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTit2   })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTit3   })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJur })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTit2+nTit3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpT150R  ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpT150R()	 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0027 + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,STR0028,STR0029)+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTot1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTot2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTot3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTot2+nTot3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³IMes150R  ³ Autor ³ Vinicius Barreira	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IMes150R()  															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0030 + "("+ALLTRIM(STR(nTotTitMes))+" "+IIF(nTotTitMes > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nMesTit1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nMesTit2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nMesTit3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nMesTitJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nMesTit2+nMesTit3 })

oSection1:PrintLine()

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ IFil150R	³ Autor ³ Paulo Boschetti 	     ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ IFil150R()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico				   									 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,oReport,oSection1,cFilSM0)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0032 + " " + cFilAnt + " - " + AllTrim(cFilSM0) })	//"T O T A L   F I L I A L ----> " 
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nFil1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nFil2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nFil3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nFilJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nFil2+nFil3 })

oSection1:PrintLine()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³HabiCel	³ Autor ³ Daniel Tadashi Batori ³ Data ³ 04/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³habilita ou desabilita celulas para imprimir totais		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ HabiCel()	 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 															  ³±±
±±³			 ³ oReport ->objeto TReport que possui as celulas 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function HabiCel(oReport)

Local oSection1 := oReport:Section(1)

oSection1:Cell("FORNECEDOR"):SetSize(50)
oSection1:Cell("TITULO"    ):Disable()
oSection1:Cell("E2_TIPO"   ):Hide()
oSection1:Cell("E2_NATUREZ"):Hide()
oSection1:Cell("E2_EMISSAO"):Hide()
oSection1:Cell("E2_VENCTO" ):Hide()
oSection1:Cell("E2_VENCREA"):Hide()
oSection1:Cell("VAL_ORIG"  ):Hide()
oSection1:Cell("E2_PORTADO"):Hide()
oSection1:Cell("DIA_ATR"   ):Hide()
oSection1:Cell("E2_HIST"   ):Disable()
oSection1:Cell("VAL_SOMA"  ):Enable()

oSection1:Cell("FORNECEDOR"):HideHeader()
oSection1:Cell("E2_TIPO"   ):HideHeader()
oSection1:Cell("E2_NATUREZ"):HideHeader()
oSection1:Cell("E2_EMISSAO"):HideHeader()
oSection1:Cell("E2_VENCTO" ):HideHeader()
oSection1:Cell("E2_VENCREA"):HideHeader()
oSection1:Cell("VAL_ORIG"  ):HideHeader()
oSection1:Cell("E2_PORTADO"):HideHeader()
oSection1:Cell("DIA_ATR"   ):HideHeader()	

Return(.T.)




/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³AjustaSx1  ³ Autor ³ Igor Nascimento   ³ Data ³ 16/11/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajusta SX1 - Remover somente na "12.1.008" ou superior  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSx1()

Local aAreasBKP := {}
Local aHelpPor  := {}
Local aHelpEng  := {}
Local aHelpSpa  := {} 
Local cPerg		:= "FIN150"
Local nTam	
Local lExistFJU := FJU->(ColumnPos("FJU_RECPAI")) >0 .and. FindFunction("FinGrvEx")
Local nTamG018  := 0
Local cGrupo    := ""
Local nI        := 0

AAdd(aAreasBKP,GetArea())	// Área de entrada

dbSelectArea("SX3")	// Campos
AAdd(aAreasBKP,GetArea())
SX3->(dbSetOrder(2))	// X3_CAMPO
SX3->(dbSeek('E1_NUM'))
cGrupo := If( SX3->(Found()),SX3->X3_GRPSXG,"018")

dbSelectArea("SXG")	// Grupo de Campos
AAdd(aAreasBKP,GetArea())
SXG->(dbSetOrder(1))	// X1_GRUPO + X1_ORDEM
nTamG018 := If( SXG->(dbSeek(cGrupo)), SXG->XG_SIZE, TAMSX3("E1_NUM")[1])

dbSelectArea("SX1")
AAdd(aAreasBKP,GetArea())
SX1->(dbSetOrder(1))

nTam := len(SX1->X1_GRUPO)

If SX1->(dbSeek(PadR(cPerg,nTam)+"37"))
	If "Excl" $ X1_PERGUNT
		RecLock("SX1", .F.)
		SX1->(DbDelete())
		MsUnlock()
	EndIf	
EndIf

// MV_PAR01:Do Numero ?                   
If SX1->(dbSeek(PadR(cPerg,nTam)+"01"))
	If X1_TAMANHO <> nTamG018 
		RecLock("SX1", .F.)
		SX1->X1_TAMANHO := nTamG018
		MsUnlock()
	EndIf	
EndIf

// MV_PAR02:Ate o Numero ?                
If SX1->(dbSeek(PadR(cPerg,nTam)+"02"))
	If X1_TAMANHO <> nTamG018 
		RecLock("SX1", .F.)
		SX1->X1_TAMANHO := nTamG018
		MsUnlock()
	EndIf	
EndIf

If !SX1->(dbSeek(PadR(cPerg,nTam)+"37"))
	aHelpPor := {"Informe se devem ser consideradas as ","filiais informadas abaixo. ","Esta pergunta não terá efeito em ","ambiente TOPCONNECT / TOTVSDBACCESS."}      
	aHelpSpa := {"Informe si deben ser consideradas las","Sucursales informadas abajo.","Esta pregunta no tendra efecto en el ","entorno TOPCONNECT / TOTVSDBACCES"}                    
	aHelpEng := {"Indicate if the branches entered below ","must be considered. ","This question does not work in ","TOPCONNECT/TOTVSDBACCESS environments."}
	
	PutSx1(cPerg,"37","Seleciona Filiais?" ,"¿Selecciona sucursales?" ,"Select Branches?","mv_chx","N",1,0,2,"C","","","","S","mv_par37","Sim","Si ","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	PutSX1Help("P."+cPerg+"37.",aHelpPor,aHelpEng,aHelpSpa,.T.)	
EndIf

If SX1->(dbSeek(PadR(cPerg,nTam)+"38"))
	If "Filiais" $ X1_PERGUNT
		RecLock("SX1", .F.)
		SX1->(DbDelete())
		MsUnlock()
	EndIf	
EndIf
 
If lExistFJU .and. !SX1->(dbSeek(PadR(cPerg,nTam)+"38"))
	aHelpPor  := {}
	aHelpEng  := {}
	aHelpSpa  := {} 
	
	Aadd( aHelpPor, "Seleciona a opção (Sim) para que" )
	Aadd( aHelpPor, "seja considerado na posição financeira os títulos")
	Aadd( aHelpPor, "excluídos conforme DataBase." )
	Aadd( aHelpPor, " Seleciona a opção (Não) será considerado " )
	Aadd( aHelpPor, "na posição financeira os títulos que não ")
	Aadd( aHelpPor, "foram deletados conforme DataBase. " )
	Aadd( aHelpSpa, "Seleccione opción sino ser considerados" )
	Aadd( aHelpSpa, "valores excluidos de acuerdo a DataBase" )
	Aadd( aHelpEng, "Select option but to be considered  " )
	Aadd( aHelpEng, "securities excluded as DateBase .  " )

	PutSx1(cPerg,"38","Considera Titulos Excluidos?" ,"?Considere Título Excluidos?" ,"Consider Title Excluded?","mv_chy","N",1,0,2,"C","","","","S","mv_par38","Sim","Si ","Yes","","Nao","No","No","","","","","","","","","")
	PutSX1Help("P."+cPerg+"38.",aHelpPor,aHelpEng,aHelpSpa,.T.)	
EndIf

For nI := Len(aAreasBKP) To 1 Step -1 
	RestArea(aAreasBKP[nI])
Next nI

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PutDtBase³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 18/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta parametro database do relat[orio.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr150.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()
//Mantida a atualização dinâmica do SX1, pois o mesmo atualiza a pergunta com a database de impressão do relatório
dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek( padr( "FIN150" , Len( x1_grupo ) , ' ' )+ "33")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return       


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AdmAbreSM0()
	Local aArea			:= SM0->( GetArea() )
	Local aAux			:= {}
	Local aRetSM0		:= {}
	Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
	Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

	If lFWLoadSM0
		aRetSM0	:= FWLoadSM0()
	Else
		DbSelectArea( "SM0" )
		SM0->( DbGoTop() )
		While SM0->( !Eof() )
			aAux := { 	SM0->M0_CODIGO,;
						IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
						"",;
						"",;
						"",;
						SM0->M0_NOME,;
						SM0->M0_FILIAL }

			aAdd( aRetSM0, aClone( aAux ) )
			SM0->( DbSkip() )
		End
	EndIf

	RestArea( aArea )
Return aRetSM0
//-------------------------------------------------------------------
/* Protheus.doc FR150DBX

Busca a data da ultima baixa realizada do titulo a pagar até a DataBase do sistema.

Author leonardo.casilva
Since 20/05/2016
Version P1180
 
Return
*/
//-------------------------------------------------------------------
Static Function FR150DBX()

Local dDataRet := SE2->E2_VENCREA
Local cQuery	 := "SELECT"

cQuery += " MAX(SE5.E5_DATA) DBAIXA"
cQuery += " FROM "+ RetSQLName( "SE5" ) + " SE5 "
cQuery += " WHERE SE5.E5_FILIAL IN ('" + xFilial("SE2")  + "') " 
cQuery += " AND SE5.E5_PREFIXO = '" + SE2->E2_PREFIXO	 + "'"
cQuery += " AND SE5.E5_NUMERO = '"  + SE2->E2_NUM		 + "'"
cQuery += " AND SE5.E5_PARCELA = '" + SE2->E2_PARCELA	 + "'"
cQuery += " AND SE5.E5_TIPO = '"	+ SE2->E2_TIPO	 	 + "'"
cQuery += " AND SE5.E5_CLIFOR = '"	+ SE2->E2_FORNECE	 + "'"
cQuery += " AND SE5.E5_LOJA = '"	+ SE2->E2_LOJA	 	 + "'"
cQuery += " AND SE5.E5_TIPODOC IN('BA','VL')"
cQuery += " AND SE5.E5_RECPAG  = 'P'"
cQuery += " AND SE5.E5_DATA <= '"	+ DTOS(dDataBase) + "'"
cQuery += " AND SE5.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBDATA",.T.,.T.)

If TRBDATA->(!EOF())
	If !Empty(AllTrim(TRBDATA->DBAIXA))
		dDataRet := STOD(TRBDATA->DBAIXA)
	Endif
EndIf
TRBDATA->(dbCloseArea())

Return dDataRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FRVlCompFil º Autor ³ Marcio Menon       º Data ³ 24/03/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Funcao que retorna o valor da compensacao de um título que  º±±
±±º          ³que foi compensado em filiais diferentes.				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³EXPC1 - Tipo da carteira:                                   º±±
±±º          ³        "R" - Contas a Receber                              º±±
±±º          ³        "P" - Contas a Pagar                                º±±
±±º          ³EXPC2 - Prefixo do titulo principal                         º±±
±±º          ³EXPC3 - Numero do titulo principal                          º±±
±±º          ³EXPC4 - Parcela do titulo principal                         º±±
±±º          ³EXPC5 - Tipo do titulo principal                            º±±
±±º          ³EXPC6 - Fornecedor do titulo principal                      º±±
±±º          ³EXPC7 - Loja do titulo principal                            º±±
±±º          ³EXPC8 - Tipo de data a ser utilizada para compor o saldo do º±±
±±º          ³        0 = Data Da Baixa (E5_DATA)                         º±±
±±º          ³        1 = Data de Disponibilidade (E5_DTDISPO)            º±±
±±º          ³        2 = Data de Contabilidação (E5_DTDIGIT)             º±±
±±º          ³EXPA9  - Vetor com todas as filiais da empresa              º±±
±±º          ³EXPC10 - Vetor com as filiais diferentes da filial atual    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FINR130 - Relatorio de Titulos a Receber                    º±±
±±º          ³FINR150 - Relatorio de Titulos a Pagar                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TFFRVlCompFil(cRecPag,cPrefixo,cNumero,cParcela,cTipo,cCliFor,cLoja,nTipoData,aFiliais,cFilQry,lAS400)
LOCAL aArea     := GetArea()
LOCAL nValor    := 0
LOCAL cTipoData := "0"
LOCAL nX        := 0
LOCAL nRegEmp	:= 0
LOCAL cEmpAnt	:= SM0->M0_CODIGO
LOCAL cFilSE5	:= xFilial("SE5")
LOCAL cTipoAdt	:= ""
LOCAL cFilAtu   := ""
Local cCpoQry   := ""
Local cWhere    := ""
LOCAL nLenFil	:= 0
LOCAL nInc		:= 0
Local aSM0		:= {}

#IFDEF TOP
	Default cFilQry	:= ""
	Default lAS400	:= (Upper(TcSrvType()) != "AS/400" .And. Upper(TcSrvType()) != "ISERIES")
#ENDIF

Default aFiliais := {}

nLenFil	:= Len( aFiliais )

// tratativa para a leitura de aFiliais. Usados nos relatorios do Financeiro
If nLenFil <= 1
	Return nValor
EndIf

nTipoData  := Iif( nTipoData == Nil, 0, nTipoData )

//Tipos de Data (cTipoData)
// 0 = Data Da Baixa (E5_DATA)
// 1 = Data de Disponibilidade (E5_DTDISPO)
// 2 = Data de Contabilidação (E5_DTDIGIT)
If nTipoData == 1
	cTipoData := "0"
ElseIf nTipodata == 2
	cTipoData := "1"
Else
	cTipoData := "2"
Endif
  
#IFDEF	TOP
	If lAS400                  
   		For nX := 1 To nLenFil
    		If aFiliais[nX] != cFilSE5
				If !Empty( cFilQry ) 
					cFilQry += ", "
				Endif
				cFilQry += "'" + aFiliais[nX] + "'"
			EndIf
		Next nX

		cQuery  := "SELECT "
			
		cCpoQry := "R_E_C_N_O_ "
		cCpoQry += "FROM " +RetSqlName("SE5") + " SE5 "
			
		cWhere  := "WHERE "
		cWhere  += "SE5.E5_FILIAL IN ( " + cFilQry  + " ) AND "
		cWhere  += "SE5.E5_PREFIXO = '"  + cPrefixo + "' AND "
		cWhere  += "SE5.E5_NUMERO = '"   + cNumero  + "' AND "
		cWhere  += "SE5.E5_PARCELA = '"  + cParcela + "' AND "
		cWhere  += "SE5.E5_TIPO = '"     + cTipo    + "' AND " 
		cWhere  += "SE5.E5_CLIFOR = '"   + cCliFor  + "' AND "
		cWhere  += "SE5.E5_LOJA = '"     + cLoja    + "' AND "
		cWhere  += "SE5.D_E_L_E_T_ = ' ' "

		cQuery  += cCpoQry
		cQuery  += cWhere

		cQuery := ChangeQuery( cQuery )
						
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T. )
		                       
		// Se existir compensacao em outras filiais, realiza query completa (performance)
		If TRB->( !EoF() )

			If cRecPag == "R"
	                  
  				dbSelectArea( "SE1" )
                           
				TRB->( dbCloseArea() )

				cQuery	:= "SELECT "			

				cCpoQry	:= "SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_FILORIG, "
				cCpoQry	+= "SE5.E5_TIPO, SE5.E5_VALOR, SE5.E5_MOTBX, SE5.E5_RECPAG, "

				If cTipoData == "0"
					cCpoQry += "SE5.E5_DATA " 
				ElseIf cTipoData == "1"
					cCpoQry += "SE5.E5_DTDISPO "
				Else	
					cCpoQry += "SE5.E5_DTDIGIT " 
				Endif

				cCpoQry  += "FROM " + RetSqlName("SE5") + " SE5, " + RetSqlName("SE1") + " SE1 "

				cWhere  += "AND "
				cWhere  += "SE1.E1_FILIAL = '"  + xFilial("SE1") + "' AND "
				cWhere  += "SE1.E1_PREFIXO = SE5.E5_PREFIXO AND "
				cWhere  += "SE1.E1_NUM = SE5.E5_NUMERO AND "    
				cWhere  += "SE1.E1_PARCELA = SE5.E5_PARCELA AND "
				cWhere  += "SE1.E1_TIPO = SE5.E5_TIPO AND "
				cWhere  += "SE1.E1_CLIENTE = SE5.E5_CLIFOR AND "
				cWhere  += "SE1.E1_LOJA = SE5.E5_LOJA AND "
				cWhere  += "SE1.D_E_L_E_T_ = ' ' "

				cQuery  += cCpoQry
				cQuery  += cWhere

				cQuery := ChangeQuery( cQuery )

				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T. )						
				TCSetField( "TRB", "E5_VALOR", "N", TamSX3("E5_VALOR")[1], TamSX3("E5_VALOR")[2] )

				If cTipoData == "0"
					TCSetField( "TRB", "E5_DATA", "D" )
				ElseIf cTipoData == "1"
					TCSetField( "TRB", "E5_DTDISPO", "D" )
				Else	
					TCSetField( "TRB", "E5_DTDIGIT", "D" )
				Endif			
				
				Do While TRB->( !Eof() )
		        
					If TRB->E5_MOTBX == "CMP" .And. TRB->E5_FILORIG == cFilSE5
	                              
						If cTipoData == "0"
							lOk := ( DtoS(TRB->E5_DATA) <= DtoS(dDataBase) )
						ElseIf cTipoData == "1"
							lOk := ( DtoS(TRB->E5_DTDISPO) <= DtoS(dDataBase) )
						Else
							lOk := ( DtoS(TRB->E5_DTDIGIT) <= DtoS(dDataBase) )
						EndIf
						
						If lOk
    						If TRB->E5_RECPAG == cRecPag
								If TRB->E5_TIPO $ MVRECANT+"|"+MV_CRNEG
									If TRB->E5_TIPODOC $ "BA|VL"
										nValor += TRB->E5_VALOR
									EndIf
								Else 
									If TRB->E5_TIPODOC $ "CP"
										nValor += TRB->E5_VALOR
									EndIf			
								EndIf                        
							EndIf							
							If TRB->E5_RECPAG == "P" .And. TRB->E5_TIPODOC == "ES"
								nValor -= TRB->E5_VALOR
							EndIf
						EndIf
					EndIf
					TRB->(dbSkip())
				EndDo
			ElseIf cRecPag == "P"

				dbSelectArea( "SE2" )
                           
				TRB->( dbCloseArea() )
    			                       
				cQuery	:= "SELECT "			

				cCpoQry	:= "SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_FILORIG, "
				cCpoQry	+= "SE5.E5_TIPO, SE5.E5_VALOR, SE5.E5_MOTBX, SE5.E5_RECPAG, "

				If cTipoData == "0"
					cCpoQry += "SE5.E5_DATA " 
				ElseIf cTipoData == "1"
					cCpoQry += "SE5.E5_DTDISPO "
				Else	
					cCpoQry += "SE5.E5_DTDIGIT " 
				Endif

				cCpoQry  += "FROM " + RetSqlName("SE5") + " SE5, " + RetSqlName("SE2") + " SE2 "
				                               
				cWhere  += "AND "
				cWhere  += "SE2.E2_FILIAL = '"  + xFilial("SE2") + "' AND "
				cWhere  += "SE2.E2_PREFIXO = SE5.E5_PREFIXO AND "
				cWhere  += "SE2.E2_NUM = SE5.E5_NUMERO AND "    
				cWhere  += "SE2.E2_PARCELA = SE5.E5_PARCELA AND "
				cWhere  += "SE2.E2_TIPO = SE5.E5_TIPO AND "
				cWhere  += "SE2.E2_FORNECE = SE5.E5_CLIFOR AND "
				cWhere  += "SE2.E2_LOJA = SE5.E5_LOJA AND "
				cWhere  += "SE2.D_E_L_E_T_ = ' ' "

				cQuery  += cCpoQry
				cQuery  += cWhere
				cQuery := ChangeQuery( cQuery )

				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T. )						

				TCSetField( "TRB", "E5_VALOR", "N", TamSX3("E5_VALOR")[1], TamSX3("E5_VALOR")[2] )

				If cTipoData == "0"
					TCSetField( "TRB", "E5_DATA", "D" )
				ElseIf cTipoData == "1"
					TCSetField( "TRB", "E5_DTDISPO", "D" )
				Else	
					TCSetField( "TRB", "E5_DTDIGIT", "D" )
				Endif			
				
				Do While TRB->( !Eof() )
		        
					If TRB->E5_MOTBX == "CMP" .And. TRB->E5_FILORIG == cFilSE5
	                              
						If cTipoData == "0"
							lOk := ( DtoS(TRB->E5_DATA) <= DtoS(dDataBase) )
						ElseIf cTipoData == "1"
							lOk := ( DtoS(TRB->E5_DTDISPO) <= DtoS(dDataBase) )
						Else
							lOk := ( DtoS(TRB->E5_DTDIGIT) <= DtoS(dDataBase) )
						EndIf
						
						If lOk
    						If TRB->E5_RECPAG == cRecPag
								If TRB->E5_TIPO $ MVPAGANT+"|"+MV_CPNEG
									If TRB->E5_TIPODOC $ "BA|VL"
										nValor += TRB->E5_VALOR
									EndIf
								Else 
									If TRB->E5_TIPODOC $ "CP"
										nValor += TRB->E5_VALOR
									EndIf			
								EndIf                        
							EndIf							
							If TRB->E5_RECPAG == "R" .And. TRB->E5_TIPODOC == "ES"
								nValor -= TRB->E5_VALOR
							EndIf	       
						EndIf
					EndIf
					TRB->(dbSkip())
				EndDo
			EndIf
		EndIf
	Else
#ENDIF
		cAlias  := Iif( cRecPag == "R", "SE1", "SE2" )
		aSM0	:= AdmAbreSM0()
		nRegEmp	:= SM0->(Recno())
		
		dbSelectArea("SM0")
		dbSeek(cEmpAnt,.T.)
		
		For nX := 1 to Len(aFiliais)

		   	cFilAtu := aFiliais[nX]

			For nInc := 1 To Len( aSM0 )
				If aSM0[nInc][1] == cEmpAnt .AND. aSM0[nInc][2] == cFilAtu
					cFilAnt := aSM0[nInc][2]

					dbSelectArea("SE5")
					dbSetOrder(7)
					// Soh processa movimentos diferentes da filial corrente. A a SaldoTit() executada antes da 
					// chamada desta funcao, jah processa a filial corrente.
					If cFilSE5 <> cFilAtu
						SE5->(MsSeek(cFilAtu+cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja))		
						While SE5->(!Eof()) .And. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) ==;
								cFilAtu+cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja
								
							If SE5->E5_MOTBX != "CMP" .And. SE5->E5_RECPAG != cRecPag
								SE5->(dbSkip())
								Loop
							Endif	
							//Defino qual o tipo de data a ser utilizado para compor o saldo do titulo
							If cTipoData == "0"
								dDtFina := SE5->E5_DATA
							ElseIf cTipoData == "1"
								dDtFina := SE5->E5_DTDISPO
							Else	
								dDtFina := SE5->E5_DTDIGIT
							Endif			
							If dDtFina > dDataBase
								SE5->(dbSkip())
								Loop
				            EndIf
				            If SE5->E5_FILORIG == cFilSE5
								cTipoAdt := Iif( cRecPag == "R", MVRECANT+"|"+MV_CRNEG, MVPAGANT+"|"+MV_CPNEG )			            
								If  SE5->E5_RECPAG == cRecPag 
									If SE5->E5_TIPO $ cTipoAdt 
										If SE5->E5_TIPODOC $ "BA|VL"
											nValor += SE5->E5_VALOR
										EndIf	
									Else
										If SE5->E5_TIPODOC $ "CP"
											nValor += SE5->E5_VALOR
										EndIf	
									EndIf
								EndIf	
								If cRecPag == "P"		// Titulos a Pagar
									If SE5->E5_RECPAG == "R" .And. SE5->E5_TIPODOC == "ES"
										nValor -= SE5->E5_VALOR
									EndIf	
								ElseIf cRecPag == "R"	// Titulos a Receber
									If SE5->E5_RECPAG == "P" .And. SE5->E5_TIPODOC == "ES"
										nValor -= SE5->E5_VALOR							
									EndIf	
								EndIf
				            Endif                 			
							SE5->(dbSkip())
				        End
				   	EndIf			
				EndIf
			Next
		Next
		dbSelectArea("SM0")
		SM0->(dbGoTo(nRegEmp))
		cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
  
#IFDEF TOP
	Endif
	If lAS400
		dbSelectArea("TRB")
		dbCloseArea()
	Endif		
#ENDIF
	
RestArea(aArea)   
Return nValor

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Tfr150IndR ³ Autor ³ Wagner           	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tfr150IndR()
Local cString
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATENCAO !!!!                                               ³
//³ N„o adiconar mais nada a chave do filtro pois a mesma est  ³
//³ com 254 caracteres.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := 'E2_FILIAL="'+xFilial()+'".And.'
cString += '(E2_MULTNAT="1" .OR. (E2_NATUREZ>="'+mv_par05+'".and.E2_NATUREZ<="'+mv_par06+'")).And.'
cString += 'E2_FORNECE>="'+mv_par11+'".and.E2_FORNECE<="'+mv_par12+'".And.'
cString += 'DTOS(E2_VENCREA)>="'+DTOS(mv_par07)+'".and.DTOS(E2_VENCREA)<="'+DTOS(mv_par08)+'".And.'
cString += 'DTOS(E2_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E2_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
	cString += '.And.E2_TIPO$"'+mv_par30+'"'
ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
	cString += '.And.!(E2_TIPO$'+'"'+mv_par31+'")'
EndIf
IF mv_par32 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E2_FLUXO!="N")'	
Endif
		
Return cString
