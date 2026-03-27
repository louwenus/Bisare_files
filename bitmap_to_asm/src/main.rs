use image::Pixel;
use regex::Regex;
use std::{borrow::Cow, env::args, process::exit};

fn main() {
    let path = args().nth(1).expect("usage: file [--fontplate]");
    let fontplate = match args().nth(2) {
        None => false,
        Some(t) => {
            if t == "--fontplate" {
                true
            } else {
                eprint!("usage: file [--fontplate]");
                exit(1)
            }
        }
    };
    let (data, name) = path_to_img(fontplate, path.as_str());
    println!("{name}:");
    for d in data {
        println!("    D 0x{d:08x}");
    }
}
fn remove_non_alphanumeric(input: &str) -> Cow<'_, str> {
    let re = Regex::new(r"[^a-zA-Z0-9_]+").unwrap();
    re.replace_all(input, "")
}

fn path_to_img(fontplate: bool, path: &str) -> (Vec<u32>, String) {
    let img = match image::open(path) {
        Ok(img) => img,
        Err(e) => panic!("failed to open image {path}: {e}"),
    };

    let width = img.width();
    let height = img.height();

    let mut bytes = Vec::new();
    if fontplate {
        let img = img.to_luma8();

        let mut bit = 0;
        let mut byte = 0;

        for y in 0..height {
            for x in 0..width {
                let pix = img.get_pixel(x, y)[0];
                if pix >= 5 {
                    byte |= 1 << bit;
                }
                bit += 1;
                if bit == 32 {
                    bytes.push(byte);
                    byte = 0;
                    bit = 0;
                }
            }
        }
        if bit != 0 {
            bytes.push(byte);
        }
    } else {
        let img = img.to_rgba8();
        bytes.push(width);
        bytes.push(height);
        for y in 0..height {
            for x in 0..width {
                let pix = img.get_pixel(x, y);
                if pix.alpha() == 0 {
                    bytes.push(0);
                } else {
                    bytes.push(u32::from_be_bytes(pix.0));
                }
            }
        }
    }
    let path = path.split('/').next_back().unwrap();
    let split: Vec<_> = path.split('.').collect();
    let name = format!(
        "picture_{}",
        remove_non_alphanumeric(&split[0..split.len() - 1].join("_")).to_lowercase()
    );
    (bytes, name)
}
