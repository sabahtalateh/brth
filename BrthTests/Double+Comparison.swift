extension Double {
    func isAlmostEqual(to other: Double, epsilon: Double = 0.000001) -> Bool {
        return abs(self - other) < epsilon
    }
}
