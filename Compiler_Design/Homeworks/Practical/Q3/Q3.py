def convert_morse_to_text(morse_code):

    morse_to_char = {
        ".-": "A", "-...": "B", "-.-.": "C", "-..": "D", ".": "E", "..-.": "F",
        "--.": "G", "....": "H", "..": "I", ".---": "J", "-.-": "K", ".-..": "L",
        "--": "M", "-.": "N", "---": "O", ".--.": "P", "--.-": "Q", ".-.": "R",
        "...": "S", "-": "T", "..-": "U", "...-": "V", ".--": "W", "-..-": "X",
        "-.--": "Y", "--..": "Z"
    }

    morse_words = morse_code.split(' / ')
    result_text = []

    for morse_word in morse_words:
        morse_chars = morse_word.split()
        decoded_word = ''
        for morse_char in morse_chars:
            if morse_char in morse_to_char:
                decoded_word += morse_to_char[morse_char]
            else:
                print(f"Warning: Invalid Morse code '{morse_char}' encountered.")
                decoded_word += '?'
        result_text.append(decoded_word)

    return ' '.join(result_text).lower()

def main(input_path, output_path):

    with open(input_path, 'r') as infile:
        morse_data = infile.read().strip()

    translated_text = convert_morse_to_text(morse_data)

    with open(output_path, 'w') as outfile:
        outfile.write(translated_text)


input_path = r'C:\Users\hoori\Desktop\HW4-9821413-hoori dahesh\Q3\input.txt'
output_path = r'C:\Users\hoori\Desktop\HW4-9821413-hoori dahesh\Q3\output.txt'

main(input_path, output_path)
