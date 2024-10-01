import os
from PIL import Image, ImageDraw, ImageFont
import re
from typing import List, Tuple, Dict, Set, Union


class GrammarParser:
    def __init__(self, grammar: Dict[str, List[str]], start_symbol: str = 'S'):
        self.grammar = grammar
        self.start_symbol = start_symbol
        self.first = {}
        self.follow = {}
        self.parse_table = {}
        self.build_first_follow()
        self.build_parse_table()

    def calculate_first(self, symbol: str) -> Set[str]:
        first_set = set()
        for production in self.grammar[symbol]:
            if not production:
                first_set.add('')
            elif production[0].isupper():
                first_set.update(self.calculate_first(production[0]))
            else:
                first_set.add(production[0])
        return first_set

    def calculate_follow(self, symbol: str, from_symbol: str = '') -> Set[str]:
        follow_set = set()
        if symbol == self.start_symbol:
            follow_set.add('$')
        for key in self.grammar:
            if from_symbol and key == from_symbol:
                continue
            for production in self.grammar[key]:
                if symbol not in production:
                    continue
                if production[-1] == symbol:
                    follow_set.update(self.calculate_follow(key, symbol or from_symbol))
                else:
                    index = production.index(symbol)
                    reached_end = True
                    for char in production[index + 1:]:
                        if char.isupper():
                            first = self.calculate_first(char)
                            if '' in first:
                                first.remove('')
                                follow_set.update(first)
                            else:
                                follow_set.update(first)
                                reached_end = False
                                break
                        else:
                            follow_set.add(char)
                            reached_end = False
                            break
                    if reached_end:
                        follow_set.update(self.calculate_follow(key, symbol))
        return follow_set

    def build_first_follow(self):
        self.first = {symbol: self.calculate_first(symbol) for symbol in self.grammar}
        self.follow = {symbol: self.calculate_follow(symbol) for symbol in self.grammar}

    def build_parse_table(self):
        self.parse_table = {symbol: {} for symbol in self.grammar}
        for symbol in self.grammar:
            for production in self.grammar[symbol]:
                if not production:
                    for terminal in self.follow[symbol]:
                        self.parse_table[symbol][terminal] = production
                else:
                    reached_end = True
                    for char in production:
                        if char.isupper():
                            if '' not in self.first[char]:
                                self.parse_table[symbol].update({term: production for term in self.first[char]})
                                reached_end = False
                                break
                            self.parse_table[symbol].update(
                                {term: production for term in self.first[char] if term != ''})
                        else:
                            self.parse_table[symbol][char] = production
                            reached_end = False
                            break
                    if reached_end:
                        for terminal in self.follow[symbol]:
                            self.parse_table[symbol][terminal] = production

    def parse_input_string(self, input_string: str) -> Union[List[Tuple[str, str]], str]:
        result = []
        stack = ['$', self.start_symbol]
        input_string += '$'
        while stack and input_string:
            top = stack.pop()
            if top.isupper():
                if top not in self.parse_table or input_string[0] not in self.parse_table[top]:
                    return 'Error'
                production = self.parse_table[top][input_string[0]]
                result.append((top, production))
                if production:
                    for char in reversed(production):
                        stack.append(char)
            else:
                if top != input_string[0]:
                    return 'Error'
                input_string = input_string[1:]
        return result

    def get_first_sets(self) -> Dict[str, Set[str]]:
        return self.first

    def get_follow_sets(self) -> Dict[str, Set[str]]:
        return self.follow


class ParseTreeBuilder:
    def __init__(self, grammar_parser: GrammarParser):
        self.grammar_parser = grammar_parser

    class Node:
        def __init__(self, value: str, children: List['Node'] = None) -> None:
            self.value = value
            self.children = children if children else []

        def __str__(self) -> str:
            return self.value

    def build_parse_tree(self, input_string: str) -> Node:
        parse_steps = self.grammar_parser.parse_input_string(input_string)
        if parse_steps == 'Error':
            raise ValueError('Invalid input string')

        root = self.Node(self.grammar_parser.start_symbol)
        stack = [root]
        for rule, production in parse_steps:
            while stack[-1].value != rule:
                stack.pop()
            current_node = stack[-1]
            if not production:
                current_node.children.append(self.Node(''))
            else:
                for char in reversed(re.sub(r'([A-Z])', r' \1 ', production).split()):
                    if char.isupper():
                        new_node = self.Node(char)
                        stack.append(new_node)
                        current_node.children.append(new_node)
                    else:
                        current_node.children.append(self.Node(char))
        self.reverse_tree(root)
        return root

    def reverse_tree(self, node: Node) -> None:
        node.children.reverse()
        for child in node.children:
            self.reverse_tree(child)


class TreeToStringConverter:
    def __init__(self):
        pass

    def convert_tree_to_string(self, node: ParseTreeBuilder.Node, pad: str = '', ptr: str = '', last: bool = True,
                               root: bool = True) -> str:
        output = '\n' + pad + ptr + self.handle_epsilon(node.value)
        if not root:
            pad += '   ' if last else ' |  '
        if node.children:
            for child in node.children[:-1]:
                output += self.convert_tree_to_string(child, pad, '├──', False, False)
            output += self.convert_tree_to_string(node.children[-1], pad, '└──', True, False)
        return output

    def handle_epsilon(self, value: str) -> str:
        if value == '':
            return "''"
        return value


class TreeImageSaver:
    def __init__(self):
        pass

    def save_text_to_image(self, filename: str, text: str, save_path: str = None) -> None:
        if save_path:
            filename = os.path.join(save_path, filename)

        img = Image.new('RGB', (700, 800), 'white')
        draw = ImageDraw.Draw(img)

        try:
            font = ImageFont.truetype("Arial.ttf", 30)
        except IOError:
            font = ImageFont.load_default()

        try:
            draw.text((10, 10), text, font=font, fill="black")
        except UnicodeEncodeError:
            text = text.encode('ascii', 'replace').decode('ascii')
            draw.text((10, 10), text, font=font, fill="black")

        img.save(filename)

        abs_path = os.path.abspath(filename)
        print(f"\nImage saved successfully at: {abs_path}")


grammar= {
    'E': ['TH'],
    'H': ['+TH', ''],
    'T': ['FA'],
    'A': ['*FA', ''],
    'F': ['(E)', 'id']
}

parser = GrammarParser(grammar, start_symbol='E')
tree_builder = ParseTreeBuilder(parser)
root_node = tree_builder.build_parse_tree('id+id*id')
converter = TreeToStringConverter()
parse_tree_str = converter.convert_tree_to_string(root_node)
saver = TreeImageSaver()


print("*******************************************")
print("First sets:")
for symbol, first_set in parser.get_first_sets().items():
    modified_first_set = {term if term != 'i' else 'id' for term in first_set}
    print(f"{symbol}: {modified_first_set}")
print("*******************************************")
print("Follow sets:")
for symbol, follow_set in parser.get_follow_sets().items():
    print(f"{symbol}: {follow_set}")
print("*******************************************")

saver.save_text_to_image('1-TREE.PNG', parse_tree_str)
print("\n*******************************************")

