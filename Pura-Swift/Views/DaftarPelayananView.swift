import SwiftUI

struct DaftarPelayananView: View {
    @EnvironmentObject var viewModel: DaftarPelayananViewModel
    @State private var showImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Informasi Pengguna")) {
                TextField("Nama Lengkap", text: $viewModel.namaLengkap)
                TextField("Kecamatan", text: $viewModel.kecamatan)
                TextField("Kelurahan", text: $viewModel.kelurahan)
                TextField("Kota", text: $viewModel.kota)
                TextField("Provinsi", text: $viewModel.provinsi)

                Picker("Jenis Kelamin", selection: $viewModel.jenisKelamin) {
                    Text("Laki-laki").tag("Laki-laki")
                    Text("Perempuan").tag("Perempuan")
                }
                .pickerStyle(MenuPickerStyle())

                TextField("Pekerjaan", text: $viewModel.pekerjaan)

                Picker("Golongan Darah", selection: $viewModel.golonganDarah) {
                    Text("A").tag("A")
                    Text("B").tag("B")
                    Text("O").tag("O")
                    Text("AB").tag("AB")
                }
                .pickerStyle(MenuPickerStyle())

                TextField("Tempat Lahir", text: $viewModel.tempatLahir)
                DatePicker("Tanggal Lahir", selection: $viewModel.tanggalLahir, displayedComponents: .date)
            }

            Section(header: Text("Pilih Jadwal")) {
                DatePicker("Tanggal Pelayanan", selection: $viewModel.jadwal, displayedComponents: .date)
            }

            Section(header: Text("Pilih Kantor")) {
                Picker("Kantor", selection: $viewModel.selectedKantorId) {
                    Text("Pilih Kantor").tag(nil as Int?)
                    ForEach(viewModel.kantorList, id: \.id) { kantor in
                        Text(kantor.nama).tag(kantor.id)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Section(header: Text("Upload Foto")) {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } else {
                    Button("Pilih Foto") {
                        showImagePicker = true
                    }
                }
            }

            Button(viewModel.isSubmitting ? "Mengirim..." : "Submit") {
                viewModel.submitForm()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isSubmitting)
        }
        .onAppear {
            print("Fetching kantor list...")
            viewModel.fetchKantorList()
        }
        .navigationTitle("Daftar Pelayanan")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.showSuccessAlert || viewModel.showErrorAlert },
            set: { _ in
                viewModel.showSuccessAlert = false
                viewModel.showErrorAlert = false
            }
        )) {
            if viewModel.showSuccessAlert {
                return Alert(
                    title: Text("Sukses"),
                    message: Text("Pendaftaran berhasil!"),
                    dismissButton: .default(Text("OK")) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            } else {
                return Alert(
                    title: Text("Gagal"),
                    message: Text("Silakan Pilih Jadwal Lain, Jadwal Sudah Penuh"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }

    }
}
