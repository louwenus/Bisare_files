// fn main() {
//     let mut bits = Vec::new();
//     for path in (1..6573).map(|i| format!("output_{i:04}.png")) {
//         path_to_img(path, &mut bits);
//     }
//     let mut agrega = Vec::new();

//     let mut bit = bits[0];
//     let mut count: usize = 0;

//     for b in bits {
//         if b == bit {
//             count += 1;
//         } else {
//             bit = b;
//             agrega.push(count);
//             count = 0;
//         }
//     }
//     agrega.push(count);

//     for v in agrega {
//         println!("{v}");
//     }

// }

// fn path_to_img(path: String, bits: &mut Vec<bool>) -> () {
//     let img = match image::open(&path) {
//         Ok(img) => img.to_luma8(),
//         Err(e) => panic!("failed to open image {path}: {e}"),
//     };

//     let width = img.width();
//     let height = img.height();

//     for y in 0..height {
//         for x in 0..width {
//             let pix = img.get_pixel(x, y)[0];
//             if pix >= 127 {
//                 bits.push(true);
//             } else {
//                 bits.push(false);
//             }
//         }
//     }
// }
// #![feature(int_lowest_highest_one)]
use std::io::stdin;

fn main() {
    let mut data = Vec::new();
    for line in stdin().lines() {
        data.push(line.unwrap().parse::<u32>().unwrap());
    }
    let mut result = Vec::new();
    let mut curr_u32 = 0u32;
    let mut occupied_bits = 0;

    for d in data {
        let d = d + 1;
        if d > 1023 {
            //push 10 0 to signal big data.
            occupied_bits += 10;
            if occupied_bits >= 32 {
                occupied_bits -= 32;
                result.push(curr_u32);
                curr_u32 = 0;
            }
            let remaining = 32 - occupied_bits;
            if remaining >= 25 {
                curr_u32 |= d << occupied_bits;
                occupied_bits += 25;
            } else {
                if occupied_bits != 32 {
                    curr_u32 |= d << occupied_bits;
                }
                result.push(curr_u32);
                curr_u32 = d >> remaining; //we already wrote these
                let too_much = 25 - remaining; // comprised in [1..25]
                occupied_bits = too_much;
            }
        } else {
            let remainning = 32 - occupied_bits;
            if remainning >= 10 {
                curr_u32 |= d << occupied_bits;
                occupied_bits += 10;
            } else {
                if occupied_bits != 32 {
                    curr_u32 |= d << occupied_bits;
                }
                result.push(curr_u32);
                curr_u32 = d >> remainning;
                let too_much = 10 - remainning;
                occupied_bits = too_much;
            }
        }
    }
    result.push(curr_u32);

    println!("bad_apple_video:");
    for v in result {
        println!("D 0x{v:x}");
    }
}
