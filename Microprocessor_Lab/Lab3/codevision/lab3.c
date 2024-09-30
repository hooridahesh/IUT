#include <header.h>

void main(void){

    init();
    func1("dahesh","9821413");
    func2();
    func3();

    #asm("sei")
    check_interrupt();

    #asm("cli");
    func5();

    while (1){} 
    
}