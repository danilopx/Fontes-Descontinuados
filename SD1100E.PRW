/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD1100E   ºAutor  ³TOTVS ABM           º Data ³  12/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para criar uma movimentacao de estorno da MOD           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#INCLUDE "PROTHEUS.CH"
User Function SD1100E()
	Local cAlias := Alias()
	Local aAreaAtual := GetArea()
	
	IF 1 = 1
		RETURN
	ENDIF  
	
	If SM0->M0_CODIGO == "01" .or. SM0->M0_CODIGO == "04"
		If !Empty(SD1->D1_OP)
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4") + SD1->D1_TES, .F.))
			If SF4->F4_ESTOQUE == "N" .AND. SD1->D1_TP = 'MO'
				SD4->(DbSetOrder(1))
				If SD4->(DbSeek(xFilial("SD4") + SD1->D1_COD + SubStr(SD1->D1_OP, 1, 8), .F.))
				
					/*
					|---------------------------------------------------------------------------------
					|	Realiza o tratamento do Reclock da tabela SD3. 
					|	Passado o MsUnlock antes das funcoes Protheus
					|
					|	Edson Hornberger - 25/06/2014
					|---------------------------------------------------------------------------------
					*/
					//Gera mov. de entrada p/produtos que não movimentam estoque e possuem empenho.
					If RecLock("SD3",.T.)
					
						Replace ;
						D3_FILIAL  With xFilial("SD3") ,D3_COD     With SD1->D1_COD,;
						D3_QUANT   With SD1->D1_QUANT  ,D3_TM      With "999",;
						D3_OP      With SD1->D1_OP     ,D3_LOCAL   With SD1->D1_LOCAL,;
						D3_DOC     With SD1->D1_DOC    ,D3_EMISSAO With SD1->D1_DTDIGIT,;
						D3_NUMSEQ  With SD1->D1_NUMSEQ ,D3_UM      With SD1->D1_UM,;
						D3_GRUPO   With SD1->D1_GRUPO  ,D3_TIPO    With SD1->D1_TP,;
						D3_SEGUM   With SD1->D1_SEGUM  ,D3_CONTA   With SD1->D1_CONTA,;
						D3_CF      With "RE5"          ,D3_QTSEGUM With SD1->D1_QTSEGUM,;
						D3_CUSTO1  With SD1->D1_CUSTO  ,D3_CUSTO2  With SD1->D1_CUSTO2,;
						D3_CUSTO3  With SD1->D1_CUSTO3 ,D3_CUSTO4  With SD1->D1_CUSTO4,;
						D3_CUSTO5  With SD1->D1_CUSTO5 ,D3_NUMLOTE With SD1->D1_NUMLOTE,;
						D3_LOTECTL With SD1->D1_LOTECTL,D3_DTVALID With SD1->D1_DTVALID,;
						D3_USUARIO With SubStr(cUsuario,7,15)
						MsUnLock()
	
						B2AtuComD3({SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5})
						C2AtuComD3({SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5})
						
					EndIf 
	
				EndIf
			EndIf
		EndIf
	EndIf
	DbSelectArea(cAlias)
	RestArea(aAreaAtual)
	
	Return