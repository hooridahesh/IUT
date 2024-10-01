def left_factoring(rules):
    rules_to_remove = []
    for rule in rules:
        for i in range(len(rule[1])):
            if rule[1][i][0] in [prod[0] for prod in rule[1][i + 1:]]:
                rules_to_remove.append(rule)
                common_prefix = rule[1][i][0]
                new_rule_alpha = (rule[0], [])
                new_rule_beta = (rule[0] + '’', [])
                remaining_productions = []
                for prod in rule[1]:
                    if common_prefix == prod[0]:
                        new_rule_beta[1].append(prod[1:])
                    else:
                        remaining_productions.append(prod)

                rules.append(new_rule_beta)
                new_rule_alpha[1].append(common_prefix + new_rule_beta[0])
                if remaining_productions:
                    for remaining in remaining_productions:
                        new_rule_alpha[1].append(remaining)
                rules.append(new_rule_alpha)
                break

    final_rules = [rule for rule in rules if rule not in rules_to_remove]

    return final_rules

def left_recursion(rules):
    start_symbols = []
    updated_rules = []
    for rule in rules:
        initial_symbols = []
        for production in rule[1]:
            initial_symbols.append(production[0])
        start_symbols.append(initial_symbols)

    for i in range(len(rules)):
        current_rule = (rules[i][0], rules[i][1])
        for j in range(i):
            if rules[j][0] in start_symbols[i]:
                symbol = rules[j][0]
                new_productions = []
                for production in rules[i][1]:
                    if production[0] == symbol:
                        sub_productions = [production.replace(symbol, r) for r in rules[j][1]]
                        new_productions.extend(sub_productions)
                    else:
                        new_productions.append(production)
                current_rule = (rules[i][0], new_productions)

        if current_rule[0] not in [prod[0] for prod in current_rule[1]]:
            updated_rules.append(current_rule)
        else:
            rule_alpha = (current_rule[0], [])
            rule_beta = (current_rule[0] + '’', [])
            for production in current_rule[1]:
                if current_rule[0] != production[0]:
                    rule_alpha[1].append(production + rule_beta[0])
                else:
                    rule_beta[1].append(production[1:] + rule_beta[0])
            rule_beta[1].append('epsilon')
            updated_rules.append(rule_alpha)
            updated_rules.append(rule_beta)

    return updated_rules

def convert_grammar(input_grammar):
    rules_list = [(non_terminal, productions) for non_terminal, productions in input_grammar.items()]
    rules_list = left_recursion(rules_list)
    rules_list = left_factoring(rules_list)
    result_grammar = {non_terminal: productions for non_terminal, productions in rules_list}
    return result_grammar

if __name__ == '__main__':
    print("\n*********************************************************************************")
    input_grammar_str = input("Enter the grammar dictionary (e.g., {'E': ['E+T', 'T'], 'T': ['T*F', 'F'], 'F': ['(E)', 'id']}): \n")
    input_grammar = eval(input_grammar_str)
    print("*********************************************************************************")

    converted_grammar = convert_grammar(input_grammar)

    print("\nConverted Grammar:")
    for non_terminal, productions in converted_grammar.items():
        print(f"{non_terminal} -> {' | '.join(productions)}")
