import Foundation

extension String {
    /// Retorna apenas os dígitos numéricos da string, descartando qualquer
    /// caractere de formatação (pontos, traços, parênteses, espaços etc.).
    var digitsOnly: String {
        filter(\.isNumber)
    }

    /// Aplica uma máscara baseada em um padrão onde cada `#` representa um
    /// dígito e os demais caracteres são separadores literais inseridos
    /// conforme o usuário digita.
    ///
    /// Ex.: `"12345678900".applyingMask("###.###.###-##")` -> `"123.456.789-00"`.
    func applyingMask(_ pattern: String) -> String {
        let digits = digitsOnly
        var result = ""
        var index = digits.startIndex

        for character in pattern {
            guard index < digits.endIndex else { break }

            if character == "#" {
                result.append(digits[index])
                index = digits.index(after: index)
            } else {
                result.append(character)
            }
        }

        return result
    }

    /// Formata a string como CPF: `000.000.000-00`.
    var maskedCPF: String {
        applyingMask("###.###.###-##")
    }

    /// Formata a string como telefone brasileiro, escolhendo o padrão de
    /// celular (11 dígitos) ou fixo (10 dígitos) conforme a quantidade digitada.
    var maskedPhone: String {
        let pattern = digitsOnly.count > 10 ? "(##) #####-####" : "(##) ####-####"
        return applyingMask(pattern)
    }

    /// Formata a string como data: `dd/MM/yyyy`.
    var maskedBirthday: String {
        applyingMask("##/##/####")
    }
}
