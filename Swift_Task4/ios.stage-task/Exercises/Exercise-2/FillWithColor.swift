import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        guard row >= 0, column >= 0, row < image.count, column < image.first!.count else { return image }
        guard image.count > 0, image.first!.count > 0 else { return image }
        
        let oldColor = image[row][column]
        guard oldColor != newColor else { return image }

        var newImage = image
        newImage[row][column] = newColor
        
        let neighbours = [(row + 1, column),
                          (row - 1, column),
                          (row, column - 1),
                          (row, column + 1)]
        
        for (nRow, nColumn) in neighbours {
            guard nRow >= 0, nColumn >= 0, nRow < image.count, nColumn < image.first!.count else { continue }
            
            if image[nRow][nColumn] == oldColor {
                newImage = fillWithColor(newImage, nRow, nColumn, newColor)
            }
        }
        
        return newImage
    }
}
