fn main() {
    swift_rs::SwiftLinker::new("10.15")
        .with_package("swift-lib", "./swift-lib/")
        .link();
}
