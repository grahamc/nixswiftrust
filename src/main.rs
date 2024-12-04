use swift_rs::{swift, SRString};

swift!(fn get_sr_string() -> SRString);

fn main() -> () {
    unsafe {
        println!("{}", get_sr_string());
    }
}
