import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var daftarPelayananViewModel: DaftarPelayananViewModel
    @State private var isShowingScanner = false

    var body: some View {
   
            VStack {
                List(viewModel.pelayanans) { pelayanan in
                    NavigationLink(destination: DetailPelayananView(pelayanan: pelayanan)) {
                        VStack(alignment: .leading) {
                            Text(pelayanan.nama_lengkap)
                                .font(.headline)
                            Text("Kantor: \(pelayanan.kantor.nama)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Jadwal: \(pelayanan.jadwal)")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingScanner = true
                    }) {
                        Label("Scan QR", systemImage: "qrcode.viewfinder")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink(destination: DaftarPelayananView().environmentObject(daftarPelayananViewModel)) {
                            Text("Daftar")
                                .fontWeight(.bold)
                        }

                        Button(action: {
                            authViewModel.logout()
                        }) {
                            Label("Logout", systemImage: "power")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                QRCodeScannerView { scannedCode in
                    isShowingScanner = false
                    if let kode = extractKode(from: scannedCode) {
                        viewModel.fetchPelayanan(kode: kode)
                    } else {
                        print("QR Code tidak valid")
                    }
                }
            }
            .sheet(item: $viewModel.pelayananDetail) { pelayanan in
                DetailPelayananView(pelayanan: pelayanan)
            }
            .onAppear {
                viewModel.fetchPelayanans()
            }
        }
    

  


}
