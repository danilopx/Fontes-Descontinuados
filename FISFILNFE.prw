// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : FISFILNFE.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 18/11/2016 | pbindo            | Gerado com aux�lio do Assistente de C�digo do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} FISFILNFE
Processa a tabela SF2-Cabecalho das NF de Saida.

@author    pbindo
@version   11.3.3.201609231349
@since     18/11/2016
/*/
//------------------------------------------------------------------------------------------
user function FISFILNFE()

If !MsgYesNo("Deseja Filtrar Notas n�o impressas?","FISFILNFE")
	Return
EndIf
	
//NOTA DE SAIDA
If SubStr(MV_PAR01,1,1) == "1"
	cCondicao += ".AND. Empty(F2__IMPR) "
Else //NOTA ENTRADA
	cCondicao += ".AND. Empty(F1__IMPR) "
EndIf


return(cCondicao)
