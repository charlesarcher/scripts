#!/bin/sh


--style=gnu   --indent=spaces=2 --indent-classes --indent-switches --indent-namespaces --break-blocks --pad-oper --keep-one-line-blocks --max-instatement-indent=79
--style=linux --indent=spaces=2 --indent-classes --indent-switches --indent-namespaces --break-blocks --pad-oper --keep-one-line-blocks --max-instatement-indent=79
--style=linux --indent=spaces=2 --indent-classes --indent-switches --indent-namespaces --break-blocks --unpad-paren --align-pointer=name --keep-one-line-blocks --max-instatement-indent=79


find ./ -name "*.h" -exec astyle  --style=linux --indent=spaces=4 --indent-classes --indent-switches --indent-namespaces --break-blocks --unpad-paren --align-pointer=name --keep-one-line-blocks --max-instatement-indent=100 {} \;
