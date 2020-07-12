DataView.prototype.writeUTF8 = function(offset, str){
    for (var i = 0; i < str.length; i++) {
        var charcode = str.charCodeAt(i);
        if (charcode < 0x80) { 
            this.setUint8(offset, charcode);
            offset++;
        }
        else if (charcode < 0x800) {
            this.setUint8(offset, (0xc0 | (charcode >> 6)));
            offset++;

            this.setUint8(offset, 0x80 | (charcode & 0x3f));
            offset++;
        }
        else if (charcode < 0xd800 || charcode >= 0xe000) {

            this.setUint8(offset, 0xe0 | (charcode >> 12));
            offset++;

            this.setUint8(offset, 0x80 | ((charcode>>6) & 0x3f));
            offset++;

            this.setUint8(offset, 0x80 | (charcode & 0x3f));
            offset++;
        }
        // surrogate pair
        else {
            i++;

            charcode = 0x10000 + (((charcode & 0x3ff)<<10)
                      | (str.charCodeAt(i) & 0x3ff));

            this.setUint8(offset, 0xf0 | (charcode >>18));
            offset++;

            this.setUint8(offset, 0x80 | ((charcode>>12) & 0x3f));
            offset++;

            this.setUint8(offset, 0x80 | ((charcode>>6) & 0x3f));
            offset++;

            this.setUint8(offset, 0x80 | (charcode & 0x3f));
            offset++;
        }
    }
}

DataView.prototype.readUTF8 = function(offset, len){
    var out, c;
    var char2, char3;

    out = "";

    while(offset < len) {
        c = this.getUint8(offset);
        offset++;
        switch(c >> 4)
        { 
        case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
            // 0xxxxxxx
            out += String.fromCharCode(c);
            break;
        case 12: case 13:
            // 110x xxxx   10xx xxxx
            char2 = array[offset++];
            out += String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
            break;
        case 14:
            // 1110 xxxx  10xx xxxx  10xx xxxx
            char2 = this.getUint8(offset);
            offset++;
            char3 = this.getUint8(offset);
            offset++;
            out += String.fromCharCode(((c & 0x0F) << 12) |
                        ((char2 & 0x3F) << 6) |
                        ((char3 & 0x3F) << 0));
            break;
        }
    }

    return out;
}

String.prototype.UTF8Length = function(){
    var totalLength = 0;
	var i;
	var charCode;
	for (i = 0; i < this.length; i++) {
		charCode = this.charCodeAt(i);
		if (charCode < 0x007f) {
			totalLength = totalLength + 1;
		} 
		else if ((0x0080 <= charCode) && (charCode <= 0x07ff)) {
			totalLength += 2;
		} 
		else if ((0x0800 <= charCode) && (charCode <= 0xffff)) {
			totalLength += 3;
		}
	}
	return totalLength; 
}

/** 
let str = "你好";
let buf = new ArrayBuffer(str.UTF8Length());

let data = new DataView(buf);
data.writeUTF8(0, str);

let value = data.readUTF8(0, str.UTF8Length());
console.log(value);
*/